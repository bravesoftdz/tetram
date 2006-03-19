object FrmEditSerie: TFrmEditSerie
  Left = 1293
  Top = 25
  Width = 750
  Height = 956
  ActiveControl = edTitre
  Caption = 'Saisie de S'#233'rie'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 23
    Width = 742
    Height = 4
    Align = alTop
    Shape = bsBottomLine
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    DesignSize = (
      742
      23)
    object btnOK: TBitBtn
      Left = 582
      Top = 2
      Width = 73
      Height = 19
      Cursor = crHandPoint
      Hint = 'Valider les modifcations'
      Anchors = [akRight, akBottom]
      Caption = 'Enregistrer'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = Frame11btnOKClick
    end
    object btnAnnuler: TBitBtn
      Left = 664
      Top = 2
      Width = 71
      Height = 19
      Cursor = crHandPoint
      Hint = 'Annuler les modifications'
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Annuler'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnAnnulerClick
    end
  end
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 27
    Width = 742
    Height = 897
    Align = alClient
    BorderStyle = bsNone
    Constraints.MinWidth = 650
    TabOrder = 1
    DesignSize = (
      742
      897)
    object Label5: TLabel
      Left = 15
      Top = 301
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editeur:'
    end
    object VDTButton1: TVDTButton
      Left = 309
      Top = 297
      Width = 20
      Height = 21
      Cursor = crHandPoint
      Caption = '...'
      Flat = True
      OnClick = EditLabeled1Click
    end
    object Label8: TLabel
      Left = 359
      Top = 301
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Collection:'
    end
    object VDTButton2: TVDTButton
      Left = 693
      Top = 297
      Width = 20
      Height = 21
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '...'
      Flat = True
      OnClick = EditLabeled2Click
    end
    object VDTButton9: TVDTButton
      Left = 329
      Top = 297
      Width = 21
      Height = 21
      Cursor = crHandPoint
      Caption = 'N'
      Flat = True
      OnClick = VDTButton9Click
    end
    object VDTButton10: TVDTButton
      Left = 713
      Top = 297
      Width = 21
      Height = 21
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'N'
      Enabled = False
      Flat = True
      OnClick = VDTButton10Click
    end
    object Label2: TLabel
      Left = 24
      Top = 7
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = ' Titre:'
      FocusControl = edTitre
      Layout = tlCenter
    end
    object Label17: TLabel
      Left = 513
      Top = 150
      Width = 33
      Height = 13
      Caption = 'Genre:'
    end
    object VDTButton3: TVDTButton
      Left = 693
      Top = 146
      Width = 20
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '...'
      Flat = True
      OnClick = ScanEditClick
    end
    object VDTButton4: TVDTButton
      Left = 713
      Top = 146
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'N'
      Flat = True
      OnClick = VDTButton4Click
    end
    object Label15: TLabel
      Left = 512
      Top = 261
      Width = 222
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = ' '
    end
    object Bevel3: TBevel
      Left = 168
      Top = 285
      Width = 411
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Bevel2: TBevel
      Left = 165
      Top = 404
      Width = 411
      Height = 7
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label6: TLabel
      Left = 13
      Top = 54
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = 'Histoire:'
      FocusControl = histoire
    end
    object Label7: TLabel
      Left = 365
      Top = 54
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Notes:'
      FocusControl = remarques
    end
    object VDTButton13: TVDTButton
      Left = 712
      Top = 30
      Width = 23
      Height = 18
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Enabled = False
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555FFFFF555555555544C4C5555555555F777775FF5555554C444C444
        5555555775FF55775F55554C4334444445555575577F55557FF554C4C334C4C4
        335557F5577FF55577F554CCC3334444335557555777F555775FCCCCC333CCC4
        C4457F55F777F555557F4CC33333CCC444C57F577777F5F5557FC4333333C3C4
        CCC57F777777F7FF557F4CC33333333C4C457F577777777F557FCCC33CC4333C
        C4C575F7755F777FF5755CCCCC3333334C5557F5FF777777F7F554C333333333
        CC55575777777777F755553333CC3C33C555557777557577755555533CC4C4CC
        5555555775FFFF77555555555C4CCC5555555555577777555555}
      NumGlyphs = 2
      OnClick = VDTButton13Click
    end
    object Label1: TLabel
      Left = 8
      Top = 32
      Width = 45
      Height = 13
      Hint = 'R'#233'f'#233'rence du support'
      Alignment = taRightJustify
      Caption = 'Site web:'
      Layout = tlCenter
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
      OnClick = btColoristeClick
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
      OnClick = btColoristeClick
    end
    object VDTButton7: TVDTButton
      Left = 191
      Top = 146
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Caption = '...'
      Flat = True
      OnClick = Edit2Change
    end
    object VDTButton8: TVDTButton
      Left = 212
      Top = 146
      Width = 20
      Height = 20
      Cursor = crHandPoint
      Caption = 'N'
      Flat = True
      OnClick = VDTButton8Click
    end
    object Label19: TLabel
      Left = 11
      Top = 150
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Auteurs:'
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
      OnClick = btColoristeClick
    end
    object Bevel5: TBevel
      Left = 189
      Top = 566
      Width = 310
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label3: TLabel
      Left = 15
      Top = 442
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Albums:'
    end
    object Label4: TLabel
      Left = 10
      Top = 575
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = 'Para-BD:'
    end
    object EditLabeled1: TEditLabeled
      Left = 56
      Top = 297
      Width = 254
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 11
      OnChange = EditLabeled1Click
      LinkLabel.LinkLabel.Strings = (
        'Label5'
        'VDTButton1')
      CurrencyChar = #0
    end
    object vtEditeurs: TVirtualStringTree
      Left = 56
      Top = 320
      Width = 294
      Height = 74
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
      TabOrder = 12
      OnChange = vtEditeursChange
      OnDblClick = vtEditeursDblClick
      Columns = <>
    end
    object EditLabeled2: TEditLabeled
      Left = 413
      Top = 297
      Width = 281
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 13
      OnChange = EditLabeled2Click
      LinkLabel.LinkLabel.Strings = (
        'Label8'
        'VDTButton2')
      CurrencyChar = #0
    end
    object vtCollections: TVirtualStringTree
      Left = 413
      Top = 320
      Width = 321
      Height = 74
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
      OnDblClick = vtCollectionsDblClick
      Columns = <>
    end
    object edTitre: TEditLabeled
      Left = 56
      Top = 4
      Width = 679
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      OnChange = edTitreChange
      LinkLabel.LinkLabel.Strings = (
        'Label2')
      CurrencyChar = #0
    end
    object ScanEdit: TEditLabeled
      Left = 552
      Top = 146
      Width = 142
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 9
      OnChange = ScanEditClick
      OnKeyPress = ScanEditKeyPress
      LinkLabel.LinkLabel.Strings = (
        'Label17'
        'VDTButton3'
        'VDTButton4')
      CurrencyChar = #0
    end
    object vtGenres: TVirtualStringTree
      Left = 512
      Top = 169
      Width = 222
      Height = 90
      Anchors = [akLeft, akTop, akRight]
      AnimationDuration = 0
      BevelKind = bkTile
      BorderStyle = bsNone
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
      TabOrder = 10
      OnChecked = vtGenresChecked
      OnDblClick = vtGenresDblClick
      OnInitNode = vtGenresInitNode
      Columns = <>
    end
    object histoire: TMemoLabeled
      Left = 56
      Top = 54
      Width = 300
      Height = 81
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 2
      LinkLabel.LinkLabel.Strings = (
        'Label6')
    end
    object remarques: TMemoLabeled
      Left = 403
      Top = 54
      Width = 332
      Height = 81
      Anchors = [akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 3
      LinkLabel.LinkLabel.Strings = (
        'Label7')
    end
    object cbTerminee: TCheckBoxLabeled
      Left = 170
      Top = 417
      Width = 90
      Height = 16
      AllowGrayed = True
      Caption = 'S'#233'rie termin'#233'e'
      State = cbGrayed
      TabOrder = 16
      LinkLabel.LinkLabel.Strings = (
        'cbTerminee')
    end
    object cbComplete: TCheckBoxLabeled
      Left = 56
      Top = 417
      Width = 90
      Height = 16
      Caption = 'S'#233'rie compl'#232'te'
      TabOrder = 15
      LinkLabel.LinkLabel.Strings = (
        'cbComplete')
    end
    object vtAlbums: TVirtualStringTree
      Left = 56
      Top = 442
      Width = 677
      Height = 119
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
      TabOrder = 17
      OnDblClick = vtAlbumsDblClick
      Columns = <>
    end
    object edSite: TEditLabeled
      Left = 56
      Top = 29
      Width = 655
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      OnChange = edSiteChange
      LinkLabel.LinkLabel.Strings = (
        'Label1')
      CurrencyChar = #0
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
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SortType = stNone
      TabOrder = 6
      ViewStyle = vsReport
      OnKeyDown = lvColoristesKeyDown
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
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SortType = stBoth
      TabOrder = 7
      ViewStyle = vsReport
      OnKeyDown = lvColoristesKeyDown
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
      TabOrder = 5
      OnChange = vtPersonnesChange
      OnDblClick = vtPersonnesDblClick
      Columns = <>
    end
    object Edit2: TEditLabeled
      Left = 56
      Top = 146
      Width = 135
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 4
      OnChange = Edit2Change
      LinkLabel.LinkLabel.Strings = (
        'Label19'
        'VDTButton7'
        'VDTButton8')
      CurrencyChar = #0
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
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SortType = stBoth
      TabOrder = 8
      ViewStyle = vsReport
      OnKeyDown = lvColoristesKeyDown
      LinkLabel.LinkLabel.Strings = (
        'btColoriste')
    end
    object vtParaBD: TVirtualStringTree
      Left = 56
      Top = 575
      Width = 673
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
      TabOrder = 18
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.StringOptions = []
      Columns = <
        item
          Position = 1
          Width = 569
        end
        item
          Position = 0
          Width = 100
        end>
    end
  end
end
