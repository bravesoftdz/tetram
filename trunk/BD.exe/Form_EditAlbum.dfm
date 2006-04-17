object FrmEditAlbum: TFrmEditAlbum
  Left = 1470
  Top = 140
  Width = 750
  Height = 856
  ActiveControl = edTitre
  Caption = 'Saisie d'#39'album'
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
    Top = 23
    Width = 742
    Height = 4
    Align = alTop
    Shape = bsBottomLine
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 27
    Width = 742
    Height = 797
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      742
      797)
    object imgVisu: TImage
      Left = 632
      Top = 592
      Width = 105
      Height = 129
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Center = True
      OnClick = imgVisuClick
    end
    object Label3: TLabel
      Left = 105
      Top = 31
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = ' Parution:'
      FocusControl = edAnneeParution
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 25
      Top = 7
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = ' Titre:'
      FocusControl = edTitre
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 14
      Top = 50
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = 'Histoire:'
      FocusControl = histoire
    end
    object Label7: TLabel
      Left = 349
      Top = 50
      Width = 32
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
      OnClick = ajoutClick
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
      OnClick = ajoutClick
    end
    object Label19: TLabel
      Left = 12
      Top = 150
      Width = 42
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
      OnClick = ChoixImageClick
    end
    object VDTButton4: TVDTButton
      Left = 609
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
      OnClick = VDTButton4Click
    end
    object VDTButton5: TVDTButton
      Left = 609
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
      OnClick = VDTButton5Click
    end
    object Bevel1: TBevel
      Left = 0
      Top = 793
      Width = 742
      Height = 4
      Align = alBottom
      Shape = bsSpacer
    end
    object Label20: TLabel
      Left = 513
      Top = 150
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie:'
      FocusControl = remarques
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
      OnClick = ajoutClick
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
    object Label5: TLabel
      Left = 406
      Top = 293
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editeur:'
    end
    object Label8: TLabel
      Left = 394
      Top = 384
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Collection:'
    end
    object Label4: TLabel
      Left = 13
      Top = 293
      Width = 41
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
      OnClick = VDTButton3Click
    end
    object Bevel3: TBevel
      Left = 216
      Top = 137
      Width = 310
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Bevel4: TBevel
      Left = 216
      Top = 280
      Width = 310
      Height = 7
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Bevel5: TBevel
      Left = 189
      Top = 582
      Width = 310
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label15: TLabel
      Left = 412
      Top = 472
      Width = 32
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
        OnClick = SpeedButton3Click
      end
      object Label9: TLabel
        Left = 190
        Top = 28
        Width = 22
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prix:'
        Layout = tlCenter
      end
      object Label10: TLabel
        Left = 0
        Top = 4
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = 'Edition:'
        Layout = tlCenter
      end
      object Label11: TLabel
        Left = 9
        Top = 52
        Width = 27
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
        OnClick = VDTButton6Click
      end
      object Label12: TLabel
        Left = 164
        Top = 79
        Width = 24
        Height = 13
        Alignment = taRightJustify
        Caption = 'Etat:'
        Layout = tlCenter
      end
      object Label13: TLabel
        Left = 151
        Top = 113
        Width = 37
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
        Left = 152
        Top = 96
        Width = 36
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
        Left = 203
        Top = 4
        Width = 49
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
        Left = 130
        Top = 130
        Width = 58
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
        Left = 150
        Top = 148
        Width = 38
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
        OnClick = VDTButton13Click
      end
      object Label24: TLabel
        Left = 97
        Top = 188
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ann'#233'e:'
        Layout = tlCenter
      end
      object Label25: TLabel
        Left = 185
        Top = 188
        Width = 27
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
        OnClick = VDTButton14Click
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
        Left = 38
        Top = 0
        Width = 46
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 0
        OnChange = edAnneeEditionChange
        LinkControls = <
          item
            Control = Label10
          end>
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
        Left = 38
        Top = 85
        Width = 34
        Height = 16
        Cursor = crHandPoint
        Caption = 'VO'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 7
        LinkControls = <
          item
            Control = cbVO
          end>
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
        LinkControls = <
          item
            Control = cbCouleur
          end>
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
        LinkControls = <
          item
            Control = cbStock
          end>
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
        LinkControls = <
          item
            Control = cbDedicace
          end>
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
        LinkControls = <
          item
            Control = Label18
          end>
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
        OnClick = cbGratuitClick
        LinkControls = <
          item
            Control = cbGratuit
          end>
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
        OnClick = cbOffertClick
        LinkControls = <
          item
            Control = cbOffert
          end>
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
        OnChange = edAnneeEditionChange
        LinkControls = <
          item
            Control = Label21
          end>
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
        LinkControls = <
          item
            Control = Label24
          end>
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
      Width = 682
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
      Top = 50
      Width = 281
      Height = 81
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 8
      LinkControls = <
        item
          Control = Label6
        end>
    end
    object remarques: TMemoLabeled
      Left = 384
      Top = 50
      Width = 354
      Height = 81
      Anchors = [akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 9
      LinkControls = <
        item
          Control = Label7
        end>
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
      OnKeyDown = lvDessinateursKeyDown
      LinkControls = <
        item
          Control = btScenariste
        end>
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
      OnKeyDown = lvDessinateursKeyDown
      LinkControls = <
        item
          Control = btDessinateur
        end>
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
      OnChange = vtPersonnesChange
      OnDblClick = vtPersonnesDblClick
      Columns = <>
    end
    object vstImages: TVirtualStringTree
      Left = 56
      Top = 591
      Width = 553
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
          Width = 449
        end
        item
          Position = 0
          Width = 100
        end>
    end
    object vtSeries: TVirtualStringTree
      Left = 550
      Top = 169
      Width = 188
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
      OnChange = vtSeriesChange
      OnDblClick = vtSeriesDblClick
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
      OnKeyDown = lvDessinateursKeyDown
      LinkControls = <
        item
          Control = btColoriste
        end>
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
      OnClick = cbIntegraleClick
      LinkControls = <
        item
          Control = cbIntegrale
        end>
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
      LinkControls = <
        item
          Control = Label1
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object vtEditeurs: TVirtualStringTree
      Left = 446
      Top = 313
      Width = 292
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
      OnChange = vtEditeursChange
      OnClick = vtEditeursClick
      OnDblClick = vtEditeursDblClick
      Columns = <>
    end
    object vtCollections: TVirtualStringTree
      Left = 446
      Top = 403
      Width = 292
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
      OnChange = vtCollectionsChange
      OnClick = vtCollectionsClick
      OnDblClick = vtCollectionsDblClick
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
      Top = 29
      Width = 73
      Height = 16
      Cursor = crHandPoint
      Caption = 'Hors s'#233'rie'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 4
      LinkControls = <
        item
          Control = cbHorsSerie
        end>
    end
    object edNotes: TMemoLabeled
      Left = 446
      Top = 472
      Width = 292
      Height = 97
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 22
      LinkControls = <
        item
          Control = Label15
        end>
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
      Top = 27
      Width = 39
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      Enabled = False
      MaxLength = 3
      TabOrder = 7
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
      Top = 27
      Width = 22
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 2
      TabOrder = 2
      LinkControls = <
        item
          Control = Label3
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    inline FrameRechercheRapidePersonnes: TFrameRechercheRapide
      Left = 56
      Top = 146
      Width = 177
      Height = 21
      TabOrder = 10
      DesignSize = (
        177
        21)
      inherited btNext: TVDTButton
        Left = 136
      end
      inherited btNew: TVDTButton
        Left = 156
      end
      inherited edSearch: TEditLabeled
        Width = 137
        LinkControls = <
          item
            Control = Label19
          end>
      end
    end
    inline FrameRechercheRapideSerie: TFrameRechercheRapide
      Left = 550
      Top = 146
      Width = 188
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 15
      DesignSize = (
        188
        21)
      inherited btNext: TVDTButton
        Left = 147
      end
      inherited btNew: TVDTButton
        Left = 167
      end
      inherited edSearch: TEditLabeled
        Width = 148
        LinkControls = <
          item
            Control = Label20
          end>
      end
    end
    inline FrameRechercheRapideEditeur: TFrameRechercheRapide
      Left = 446
      Top = 290
      Width = 292
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 18
      DesignSize = (
        292
        21)
      inherited btNext: TVDTButton
        Left = 251
      end
      inherited btNew: TVDTButton
        Left = 271
      end
      inherited edSearch: TEditLabeled
        Width = 252
        LinkControls = <
          item
            Control = Label5
          end>
      end
    end
    inline FrameRechercheRapideCollection: TFrameRechercheRapide
      Left = 446
      Top = 380
      Width = 292
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 20
      DesignSize = (
        292
        21)
      inherited btNext: TVDTButton
        Left = 251
      end
      inherited btNew: TVDTButton
        Left = 271
        Enabled = False
      end
      inherited edSearch: TEditLabeled
        Width = 252
        LinkControls = <
          item
            Control = Label8
          end>
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    DesignSize = (
      742
      23)
    object btnOK: TBitBtn
      Left = 579
      Top = 2
      Width = 74
      Height = 19
      Cursor = crHandPoint
      Anchors = [akRight, akBottom]
      Caption = 'Enregistrer'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnAnnuler: TBitBtn
      Left = 660
      Top = 2
      Width = 72
      Height = 19
      Cursor = crHandPoint
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Annuler'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnAnnulerClick
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
  object ImageList1: TImageList
    Left = 344
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
