object FrmEditAchatAlbum: TFrmEditAchatAlbum
  Left = 245
  Top = 418
  Width = 738
  Height = 412
  Caption = 'Achat'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 730
    Height = 349
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    Style = tsButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Nouvel album'
      DesignSize = (
        722
        318)
      object Label3: TLabel
        Left = 97
        Top = 31
        Width = 47
        Height = 13
        Alignment = taRightJustify
        Caption = ' Parution:'
        FocusControl = edAnneeParution
        Layout = tlCenter
      end
      object Bevel3: TBevel
        Left = 206
        Top = 137
        Width = 310
        Height = 6
        Shape = bsTopLine
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
      object Label20: TLabel
        Left = 506
        Top = 150
        Width = 28
        Height = 13
        Alignment = taRightJustify
        Caption = 'S'#233'rie:'
      end
      object Label1: TLabel
        Left = 13
        Top = 31
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = ' Tome:'
        FocusControl = edTome
        Layout = tlCenter
      end
      object Label2: TLabel
        Left = 17
        Top = 7
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = ' Titre:'
        FocusControl = edTitre
        Layout = tlCenter
      end
      object btScenariste: TVDTButton
        Tag = 1
        Left = 228
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
        OnClick = btScenaristeClick
      end
      object btDessinateur: TVDTButton
        Tag = 2
        Left = 228
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
        OnClick = btScenaristeClick
      end
      object Label19: TLabel
        Left = 4
        Top = 150
        Width = 42
        Height = 13
        Alignment = taRightJustify
        Caption = 'Auteurs:'
      end
      object btColoriste: TVDTButton
        Tag = 3
        Left = 228
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
        OnClick = btScenaristeClick
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
      object Label6: TLabel
        Left = 6
        Top = 50
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Histoire:'
        FocusControl = histoire
      end
      object btResetSerie: TCRFurtifLight
        Left = 698
        Top = 146
        Width = 20
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Enabled = False
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000CC00CCCC00CC
          CC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00
          CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CC9898A3ADADB4CC00CCCC00CCCC
          00CCCC00CCCC00CCCC00CCA9A9B1A9A9B1CC00CCCC00CCCC00CCCC00CCCC00CC
          4A4C7D000CAE0A0E62A2A2ABCC00CCCC00CCCC00CCCC00CC7C7C8D01098D0009
          9661617BCC00CCCC00CCCC00CC92929F0010C9000DEA0004D3090D61A0A0A9CC
          00CCCC00CC81819101099A0003D10011F5020979C1C1C3CC00CCCC00CC9B9BA6
          020D970015FF000BE70004D3080C659E9EA8868694020A950003D2000FF10014
          F2141860C8C8C9CC00CCCC00CCCC00CC8D8D9B020C980015FF000CE80004D306
          0A64020A8F0003D3000FF00014F40E1366AEAEB4CC00CCCC00CCCC00CCCC00CC
          CC00CC91919E030D930015FF000CE80004D30003D3000EEE0014F70A0F66A8A8
          B0CC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CC9595A1040D8E0015FF00
          0EEF000FF10014F8060C69A1A1AACC00CCCC00CCCC00CCCC00CCCC00CCCC00CC
          CC00CCCC00CC92929E030B7B0318FE8394F47A8BF50216F902086B868694CC00
          CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CC9797A2040B760116FD93A5F294
          A6F1A5B6F195A7F20318FA02086D818191CC00CCCC00CCCC00CCCC00CCCC00CC
          9C9CA6060D720015FC899BF39BACF1080F740C1688A1B2F09AAAF20419FB0108
          6E7C7C8DCC00CCCC00CCCC00CCB7B7BB090E670015FA7D8FF4A4B4F009107795
          95A1A3A3AC0E17839CADF19EAFF1051AFC010767A1A1AACC00CCCC00CCB7B7BB
          030A762B3FFB9DAEF109117991919ECC00CCCC00CCA8A8B00F167E8C9DF13F52
          FA020A79AAAAB1CC00CCCC00CCCC00CC7F7F90040B7902086B8C8C9ACC00CCCC
          00CCCC00CCCC00CCACACB30F1571020A7C767689CC00CCCC00CCCC00CCCC00CC
          CC00CCB7B7BBAEAEB4CC00CCCC00CCCC00CCCC00CCCC00CCCC00CCC0C0C3BBBB
          BFCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC
          00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CCCC00CC}
        OnClick = btResetSerieClick
      end
      object edAnneeParution: TEditLabeled
        Left = 167
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
        Left = 48
        Top = 4
        Width = 671
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
      object vtSeries: TVirtualStringTree
        Left = 541
        Top = 169
        Width = 177
        Height = 106
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
        Left = 48
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
      object lvScenaristes: TVDTListViewLabeled
        Left = 297
        Top = 146
        Width = 198
        Height = 41
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = <
          item
          end>
        ColumnClick = False
        HideSelection = False
        OwnerData = True
        ReadOnly = True
        ShowColumnHeaders = False
        SortType = stNone
        TabOrder = 12
        ViewStyle = vsReport
        OnData = lvScenaristesData
        OnKeyDown = lvColoristesKeyDown
        LinkControls = <
          item
            Control = btScenariste
          end>
      end
      object lvDessinateurs: TVDTListViewLabeled
        Left = 297
        Top = 190
        Width = 198
        Height = 41
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = <
          item
          end>
        ColumnClick = False
        HideSelection = False
        OwnerData = True
        ReadOnly = True
        ShowColumnHeaders = False
        SortType = stBoth
        TabOrder = 13
        ViewStyle = vsReport
        OnData = lvDessinateursData
        OnKeyDown = lvColoristesKeyDown
        LinkControls = <
          item
            Control = btDessinateur
          end>
      end
      object vtPersonnes: TVirtualStringTree
        Left = 48
        Top = 169
        Width = 177
        Height = 106
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
      object lvColoristes: TVDTListViewLabeled
        Left = 297
        Top = 234
        Width = 198
        Height = 41
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = <
          item
          end>
        ColumnClick = False
        HideSelection = False
        OwnerData = True
        ReadOnly = True
        ShowColumnHeaders = False
        SortType = stBoth
        TabOrder = 14
        ViewStyle = vsReport
        OnData = lvColoristesData
        OnKeyDown = lvColoristesKeyDown
        LinkControls = <
          item
            Control = btColoriste
          end>
      end
      object edMoisParution: TEditLabeled
        Left = 144
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
      object remarques: TMemoLabeled
        Left = 384
        Top = 50
        Width = 334
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
      object histoire: TMemoLabeled
        Left = 48
        Top = 50
        Width = 289
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
      inline FrameRechercheRapidePersonnes: TFrameRechercheRapide
        Left = 48
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
        Left = 541
        Top = 146
        Width = 156
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 15
        DesignSize = (
          156
          21)
        inherited btNext: TVDTButton
          Left = 115
        end
        inherited btNew: TVDTButton
          Left = 135
        end
        inherited edSearch: TEditLabeled
          Width = 116
          LinkControls = <
            item
              Control = Label20
            end>
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Album existant'
      ImageIndex = 1
      DesignSize = (
        722
        318)
      object Label4: TLabel
        Left = 13
        Top = 7
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Album:'
        Layout = tlCenter
      end
      object vstAlbums: TVirtualStringTree
        Left = 48
        Top = 27
        Width = 670
        Height = 248
        Anchors = [akLeft, akTop, akRight]
        AnimationDuration = 0
        BackgroundOffsetY = 24
        BevelKind = bkTile
        BorderStyle = bsNone
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
        HintAnimation = hatNone
        HintMode = hmTooltip
        HotCursor = crHandPoint
        Indent = 8
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Columns = <
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
            Position = 0
            Width = 670
          end>
      end
      inline FrameRechercheRapideAlbums: TFrameRechercheRapide
        Left = 48
        Top = 4
        Width = 670
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        DesignSize = (
          670
          21)
        inherited btNext: TVDTButton
          Left = 629
        end
        inherited btNew: TVDTButton
          Left = 649
        end
        inherited edSearch: TEditLabeled
          Width = 630
          LinkControls = <
            item
              Control = Label4
            end>
        end
      end
    end
  end
  inline Frame11: TFrame1
    Left = 0
    Top = 349
    Width = 730
    Height = 31
    Align = alBottom
    TabOrder = 1
    inherited btnOK: TBitBtn
      Left = 551
      Top = 8
      Width = 87
      Height = 19
      Caption = 'Ok'
      OnClick = Frame11btnOKClick
    end
    inherited btnAnnuler: TBitBtn
      Left = 647
      Top = 8
      Width = 72
      Height = 19
    end
  end
end
