object FieldMapEditor: TFieldMapEditor
  Left = 8
  Top = 133
  Width = 335
  Height = 316
  BorderIcons = [biMaximize]
  BorderStyle = bsSizeToolWin
  Caption = 'Editeur des champs de transfert'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 228
    Height = 289
    Align = alClient
    BevelOuter = bvLowered
    BorderWidth = 3
    TabOrder = 0
    OnResize = Panel1Resize
    object FGrid: THDBGrid
      Left = 4
      Top = 4
      Width = 220
      Height = 281
      Align = alClient
      DataSource = DS
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnExit = FGridExit
      SpHint = True
      AutoSizeLastColumn = True
      Columns = <
        item
          DropDownRows = 15
          Expanded = False
          FieldName = 'Source'
          Width = 94
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Destination'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ReadOnly = True
          Width = 108
          Visible = True
        end>
    end
  end
  object Panel2: TPanel
    Left = 228
    Top = 0
    Width = 99
    Height = 289
    Align = alRight
    TabOrder = 1
    object btnOk: TBitBtn
      Left = 6
      Top = 4
      Width = 87
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = ExitPanel1OkClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330300333333333333333333333333F33333333333
        A5013333344333333333333333388F3333333333A50133334224333333333333
        338338F333333333D001333422224333333333333833338F33333333F9013342
        222224333333333383333338F3333333350134222A22224333333338F338F333
        8F33333304003222A3A2224333333338F3838F338F33333300A03A2A333A2224
        33333338F83338F338F33333B68133A33333A222433333338333338F338F3333
        5600333333333A222433333333333338F338F33391003333333333A222433333
        333333338F338F33350133333333333A222433333333333338F338F3A1013333
        33333333A222433333333333338F338FF9013333333333333A22433333333333
        3338F38F020033333333333333A223333333333333338F83F901333333333333
        333A333333333333333338330200333333333333333333333333333333333333
        9C01}
      NumGlyphs = 2
    end
    object btnCancel: TBitBtn
      Left = 6
      Top = 32
      Width = 87
      Height = 25
      Caption = 'Annuler'
      ModalResult = 2
      TabOrder = 1
      OnClick = CancelBtnClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333050033338833333333333333333F333333333333
        AB01333911833333983333333388F333333F3333A80133391118333911833333
        38F38F333F88F333F5013339111183911118333338F338F3F8338F3306003333
        911118111118333338F3338F833338F3060033333911111111833333338F3338
        3333F8330200333333911111183333333338F333333F83334C6F333333311111
        8333333333338F3333383333F60133333339111183333333333338F333833333
        F6013333339111118333333333333833338F3333350133333911181118333333
        33338333338F333304003333911183911183333333383338F338F33300F03333
        9118333911183333338F33838F338F33FFFF33333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF834E00333333333333
        3333333333333333333888330400333333333333333333333333333333333333
        F600}
      NumGlyphs = 2
    end
    object btnClear: TBitBtn
      Left = 6
      Top = 68
      Width = 87
      Height = 25
      Caption = 'R'#233'initialiser'
      TabOrder = 2
      OnClick = btnClearClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
    end
    object btnAuto: TBitBtn
      Left = 6
      Top = 96
      Width = 87
      Height = 25
      Caption = 'Automatique'
      TabOrder = 3
      OnClick = btnAutoClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003FFFFFFFFFFF
        FFFF33333333333FFFFF3FFFFFFFFF00000F333333333377777F33FFFFFFFF09
        990F33333333337F337F333FFFFFFF09990F33333333337F337F3333FFFFFF09
        990F33333333337FFF7F33333FFFFF00000F3333333333777773333333FFFFFF
        FFFF3333333333333F333333333FFFFF0FFF3333333333337FF333333333FFF0
        00FF33333333333777FF333333333F00000F33FFFFF33777777F300000333000
        0000377777F33777777730EEE033333000FF37F337F3333777F330EEE0333330
        00FF37F337F3333777F330EEE033333000FF37FFF7F333F77733300000333000
        03FF3777773337777333333333333333333F3333333333333333}
      NumGlyphs = 2
    end
  end
  object DS: TDataSource
    DataSet = VDataSet
    Left = 200
    Top = 104
  end
  object VDataSet: TVirtualDataSet
    IndexOptions = []
    AnsiCompare = False
    ExportFormat = efDataSet
    ExportCalcFields = False
    CachedUpdates = False
    BeforeDelete = VDataSetBeforeDelete
    Left = 200
    Top = 72
    object VDataSetSource: TStringField
      FieldName = 'Source'
      Size = 255
    end
    object VDataSetDest: TStringField
      FieldName = 'Destination'
      Size = 255
    end
  end
end
