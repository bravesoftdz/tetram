object FrmEditAchat: TFrmEditAchat
  Left = 354
  Top = 555
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
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 730
    Height = 354
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    Style = tsButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Nouvel album'
      DesignSize = (
        722
        323)
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
      object VDTButton12: TVDTButton
        Left = 677
        Top = 146
        Width = 20
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = '...'
        Flat = True
        OnClick = VDTButton12Click
      end
      object VDTButton11: TVDTButton
        Left = 697
        Top = 146
        Width = 21
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = 'N'
        Flat = True
        OnClick = VDTButton11Click
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
      object VDTButton7: TVDTButton
        Left = 183
        Top = 146
        Width = 21
        Height = 20
        Cursor = crHandPoint
        Caption = '...'
        Flat = True
        OnClick = VDTButton7Click
      end
      object VDTButton8: TVDTButton
        Left = 204
        Top = 146
        Width = 20
        Height = 20
        Cursor = crHandPoint
        Caption = 'N'
        Flat = True
        OnClick = VDTButton8Click
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
      object edAnneeParution: TEditLabeled
        Left = 167
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
        Left = 48
        Top = 4
        Width = 670
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        LinkLabel.LinkLabel.Strings = (
          'Label2')
        CurrencyChar = #0
      end
      object Edit3: TEditLabeled
        Left = 541
        Top = 146
        Width = 137
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 13
        OnChange = VDTButton12Click
        LinkLabel.LinkLabel.Strings = (
          'Label20'
          'VDTButton11'
          'VDTButton12')
        CurrencyChar = #0
      end
      object vtSeries: TVirtualStringTree
        Left = 541
        Top = 169
        Width = 177
        Height = 104
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
        TabOrder = 14
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
        LinkLabel.LinkLabel.Strings = (
          'cbIntegrale')
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
        LinkLabel.LinkLabel.Strings = (
          'Label1')
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
        LinkLabel.LinkLabel.Strings = (
          'cbHorsSerie')
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
        ReadOnly = True
        ShowColumnHeaders = False
        SortType = stNone
        TabOrder = 10
        ViewStyle = vsReport
        OnKeyDown = lvColoristesKeyDown
        LinkLabel.LinkLabel.Strings = (
          'btScenariste')
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
        ReadOnly = True
        ShowColumnHeaders = False
        SortType = stBoth
        TabOrder = 11
        ViewStyle = vsReport
        OnKeyDown = lvColoristesKeyDown
        LinkLabel.LinkLabel.Strings = (
          'btDessinateur')
      end
      object vtPersonnes: TVirtualStringTree
        Left = 48
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
        TabOrder = 9
        OnChange = vtPersonnesChange
        OnDblClick = vtPersonnesDblClick
        Columns = <>
      end
      object Edit2: TEditLabeled
        Left = 48
        Top = 146
        Width = 135
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 8
        OnChange = VDTButton7Click
        LinkLabel.LinkLabel.Strings = (
          'Label19'
          'VDTButton7'
          'VDTButton8')
        CurrencyChar = #0
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
        ReadOnly = True
        ShowColumnHeaders = False
        SortType = stBoth
        TabOrder = 12
        ViewStyle = vsReport
        OnKeyDown = lvColoristesKeyDown
        LinkLabel.LinkLabel.Strings = (
          'btColoriste')
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
        LinkLabel.LinkLabel.Strings = (
          'Label3')
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object remarques: TMemoLabeled
        Left = 384
        Top = 50
        Width = 338
        Height = 81
        Anchors = [akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        ScrollBars = ssVertical
        TabOrder = 15
        LinkLabel.LinkLabel.Strings = (
          'Label7')
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
        TabOrder = 16
        LinkLabel.LinkLabel.Strings = (
          'Label6')
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Album existant'
      ImageIndex = 1
      DesignSize = (
        722
        323)
      object VDTButton1: TVDTButton
        Left = 697
        Top = 4
        Width = 20
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = '...'
        Flat = True
        OnClick = ScanEditAlbumClick
      end
      object Label4: TLabel
        Left = 13
        Top = 7
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Album:'
        FocusControl = ScanEditAlbum
        Layout = tlCenter
      end
      object ScanEditAlbum: TEdit
        Left = 48
        Top = 4
        Width = 648
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        OnChange = ScanEditAlbumClick
      end
      object vstAlbums: TVirtualStringTree
        Left = 48
        Top = 29
        Width = 670
        Height = 164
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
            Width = 666
          end>
      end
    end
  end
  inline Frame11: TFrame1
    Left = 0
    Top = 354
    Width = 730
    Height = 31
    Align = alBottom
    TabOrder = 1
    inherited btnOK: TBitBtn
      Left = 559
      Top = 8
      Width = 73
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
