object FrmConsultationAlbum: TFrmConsultationAlbum
  Left = 145
  Top = 98
  Width = 530
  Height = 833
  Caption = 'Fiche d'#39'album'
  Color = clWhite
  Constraints.MinWidth = 530
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 0
    Width = 522
    Height = 781
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 0
    DesignSize = (
      522
      781)
    object Label4: TLabel
      Left = 364
      Top = 164
      Width = 89
      Height = 21
      Alignment = taCenter
      Anchors = [akTop, akRight]
      Caption = 'Pas d'#39'image'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object l_remarques: TLabel
      Left = 25
      Top = 392
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes'
      Color = clWhite
      FocusControl = remarques
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_sujet: TLabel
      Left = 17
      Top = 321
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Histoire'
      Color = clWhite
      FocusControl = sujet
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 19
      Top = 94
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Genres'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_annee: TLabel
      Left = 25
      Top = 11
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie:'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object l_acteurs: TLabel
      Left = 17
      Top = 176
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Dessins'
      Color = clWhite
      FocusControl = lvDessinateurs
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_realisation: TLabel
      Left = 12
      Top = 135
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Scenario'
      Color = clWhite
      FocusControl = lvScenaristes
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 29
      Top = 259
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object TitreAlbum: TLabel
      Left = 59
      Top = 27
      Width = 455
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Titre'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
    end
    object Label6: TLabel
      Left = 27
      Top = 33
      Width = 26
      Height = 13
      Alignment = taRightJustify
      Caption = 'Titre:'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object VDTButton3: TVDTButton
      Left = 471
      Top = 299
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        B2000000424DB20000000000000052000000280000000C0000000C0000000100
        04000000000060000000120B0000120B00000700000007000000CE636300FF9C
        9C00FFCECE0000FF0000BDBDBD008C8C8C000000000033333333343320603333
        3333654333333333333665433333333333616543333333333610654333333333
        6110654333333336211065433333333362106543333633333621654333333333
        33626543333333333336654333333333333364333333}
      Visible = False
      OnClick = VDTButton2Click
    end
    object VDTButton4: TVDTButton
      Left = 495
      Top = 299
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        B2000000424DB20000000000000052000000280000000C0000000C0000000100
        04000000000060000000120B0000120B00000700000007000000CE636300FF9C
        9C00FFCECE0000FF0000BDBDBD008C8C8C000000000033334333333360603336
        5433333333333336654333333336333616543333333633362065433333363336
        2106543333363336211063333336333621163333333633362163333333363336
        26333333333633366333333333363336333333333336}
      Visible = False
      OnClick = VDTButton1Click
    end
    object Label7: TLabel
      Left = 11
      Top = 218
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Couleurs'
      Color = clWhite
      FocusControl = lvColoristes
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label11: TLabel
      Left = 9
      Top = 67
      Width = 44
      Height = 13
      Alignment = taRightJustify
      Caption = 'Parution:'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object AnneeParution: TLabel
      Left = 59
      Top = 67
      Width = 70
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Parution'
      Transparent = True
    end
    object TitreSerie: TLabel
      Left = 59
      Top = 5
      Width = 455
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'S'#233'rie'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
      OnClick = TitreSerieClick
      OnDblClick = TitreSerieDblClick
    end
    object Label14: TLabel
      Left = 23
      Top = 52
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Tome:'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object Tome: TLabel
      Left = 59
      Top = 52
      Width = 70
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Tome'
      Transparent = True
    end
    object Bevel1: TBevel
      Left = 0
      Top = 778
      Width = 522
      Height = 3
      Align = alBottom
      Shape = bsSpacer
    end
    object Label18: TLabel
      Left = 351
      Top = 204
      Width = 114
      Height = 42
      Alignment = taCenter
      Anchors = [akTop, akRight]
      Caption = 'Impossible de charger l'#39'image'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      Visible = False
      WordWrap = True
    end
    object Couverture: TImage
      Left = 301
      Top = 51
      Width = 215
      Height = 246
      Anchors = [akTop, akRight]
      Center = True
      IncrementalDisplay = True
    end
    object remarques: TMemo
      Left = 59
      Top = 392
      Width = 457
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object sujet: TMemo
      Left = 59
      Top = 320
      Width = 457
      Height = 67
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object lvScenaristes: TVDTListView
      Left = 59
      Top = 135
      Width = 233
      Height = 35
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      Columns = <
        item
          MinWidth = 150
          Width = 231
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      TabOrder = 2
      ViewStyle = vsReport
      OnDblClick = lvScenaristesDblClick
    end
    object lvDessinateurs: TVDTListView
      Left = 59
      Top = 176
      Width = 233
      Height = 36
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      Columns = <
        item
          MinWidth = 150
          Width = 231
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SortType = stData
      TabOrder = 3
      ViewStyle = vsReport
      OnDblClick = lvScenaristesDblClick
    end
    object lvSerie: TVDTListView
      Left = 59
      Top = 259
      Width = 233
      Height = 56
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      Columns = <
        item
          MinWidth = 140
          Width = 231
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SmallImages = Fond.ShareImageList
      SortType = stNone
      TabOrder = 4
      ViewStyle = vsReport
      OnDblClick = lvSerieDblClick
    end
    object Memo1: TMemo
      Left = 59
      Top = 94
      Width = 233
      Height = 34
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object lvColoristes: TVDTListView
      Left = 59
      Top = 218
      Width = 233
      Height = 36
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Color = clWhite
      Columns = <
        item
          Width = 46
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SortType = stData
      TabOrder = 6
      ViewStyle = vsReport
      OnDblClick = lvScenaristesDblClick
    end
    object Integrale: TReadOnlyCheckBox
      Left = 171
      Top = 50
      Width = 126
      Height = 16
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Int'#233'grale'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 7
    end
    object HorsSerie: TReadOnlyCheckBox
      Left = 171
      Top = 65
      Width = 68
      Height = 16
      TabStop = False
      Caption = 'Hors s'#233'rie'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 9
    end
    object PanelEdition: TPanel
      Left = 3
      Top = 467
      Width = 513
      Height = 310
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      Caption = ' '
      ParentColor = True
      TabOrder = 10
      DesignSize = (
        513
        310)
      object ISBN: TLabel
        Left = 56
        Top = 2
        Width = 23
        Height = 13
        Caption = 'ISBN'
      end
      object Editeur: TLabel
        Left = 56
        Top = 18
        Width = 34
        Height = 13
        Caption = 'Editeur'
        ShowAccelChar = False
        OnClick = EditeurClick
      end
      object Prix: TLabel
        Left = 56
        Top = 52
        Width = 18
        Height = 13
        Caption = 'Prix'
      end
      object Lbl_numero: TLabel
        Left = 23
        Top = 2
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'ISBN:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Lbl_type: TLabel
        Left = 12
        Top = 18
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = 'Editeur:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label3: TLabel
        Left = 28
        Top = 52
        Width = 22
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prix:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label2: TLabel
        Left = 14
        Top = 173
        Width = 45
        Height = 13
        Caption = 'Emprunts'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ShowAccelChar = False
        Transparent = True
      end
      object nbemprunts: TLabel
        Left = 71
        Top = 157
        Width = 3
        Height = 13
        Transparent = True
      end
      object Label9: TLabel
        Left = 0
        Top = 35
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = 'Collection:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Collection: TLabel
        Left = 56
        Top = 35
        Width = 46
        Height = 13
        Caption = 'Collection'
        ShowAccelChar = False
      end
      object Label16: TLabel
        Left = 265
        Top = 18
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ann'#233'e:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object AnneeEdition: TLabel
        Left = 305
        Top = 18
        Width = 31
        Height = 13
        Caption = 'Ann'#233'e'
      end
      object Etat: TLabel
        Left = 56
        Top = 85
        Width = 20
        Height = 13
        Caption = 'Etat'
        ShowAccelChar = False
      end
      object Label10: TLabel
        Left = 26
        Top = 85
        Width = 24
        Height = 13
        Alignment = taRightJustify
        Caption = 'Etat:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Reliure: TLabel
        Left = 208
        Top = 85
        Width = 33
        Height = 13
        Caption = 'Reliure'
        ShowAccelChar = False
      end
      object Label13: TLabel
        Left = 163
        Top = 85
        Width = 37
        Height = 13
        Alignment = taRightJustify
        Caption = 'Reliure:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object TypeEdition: TLabel
        Left = 350
        Top = 85
        Width = 32
        Height = 13
        Caption = 'Edition'
        ShowAccelChar = False
      end
      object Label8: TLabel
        Left = 18
        Top = 118
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Notes:'
        Color = clWhite
        FocusControl = edNotes
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label12: TLabel
        Left = 151
        Top = 52
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'Achet'#233' le:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object AcheteLe: TLabel
        Left = 208
        Top = 52
        Width = 45
        Height = 13
        Caption = 'Achet'#233' le'
      end
      object Label15: TLabel
        Left = 17
        Top = 101
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Pages:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Pages: TLabel
        Left = 56
        Top = 101
        Width = 29
        Height = 13
        Caption = 'Pages'
      end
      object Label17: TLabel
        Left = 142
        Top = 101
        Width = 58
        Height = 13
        Alignment = taRightJustify
        Caption = 'Orientation:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbOrientation: TLabel
        Left = 208
        Top = 101
        Width = 54
        Height = 13
        Caption = 'Orientation'
        ShowAccelChar = False
      end
      object Label19: TLabel
        Left = 350
        Top = 101
        Width = 38
        Height = 13
        Caption = 'Format:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbFormat: TLabel
        Left = 392
        Top = 101
        Width = 34
        Height = 13
        Caption = 'Format'
        ShowAccelChar = False
      end
      object lbCote: TLabel
        Left = 56
        Top = 68
        Width = 23
        Height = 13
        Caption = 'Cote'
      end
      object Label20: TLabel
        Left = 23
        Top = 68
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cote:'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object cbVO: TReadOnlyCheckBox
        Left = 213
        Top = 17
        Width = 33
        Height = 16
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'VO'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 0
      end
      object ListeEmprunts: TVirtualStringTree
        Left = 8
        Top = 192
        Width = 505
        Height = 116
        Anchors = [akLeft, akTop, akRight]
        AnimationDuration = 0
        BevelInner = bvLowered
        BevelOuter = bvNone
        BevelKind = bkFlat
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
        Header.AutoSizeIndex = 1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Images = Fond.ImageList1
        Header.MainColumn = 1
        Header.Options = [hoAutoResize, hoColumnResize, hoShowImages, hoVisible]
        Header.Style = hsPlates
        HotCursor = crHandPoint
        Images = Fond.ImageList1
        TabOrder = 1
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
        OnDblClick = ListeEmpruntsDblClick
        OnGetText = ListeEmpruntsGetText
        OnGetImageIndex = ListeEmpruntsGetImageIndex
        OnHeaderClick = ListeEmpruntsHeaderClick
        Columns = <
          item
            Position = 0
            Width = 100
            WideText = 'Date'
          end
          item
            Position = 1
            Width = 403
            WideText = 'Emprunteur'
          end>
      end
      object ajouter: TButton
        Left = 441
        Top = 170
        Width = 72
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = 'Ajouter'
        Enabled = False
        TabOrder = 2
        OnClick = ajouterClick
      end
      object cbCouleur: TReadOnlyCheckBox
        Left = 262
        Top = 34
        Width = 56
        Height = 15
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Couleur'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 3
      end
      object cbStock: TReadOnlyCheckBox
        Left = 273
        Top = 1
        Width = 45
        Height = 15
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Stock'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 4
      end
      object edNotes: TMemo
        Left = 56
        Top = 118
        Width = 457
        Height = 40
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvLowered
        BevelKind = bkFlat
        BevelOuter = bvNone
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object cbOffert: TReadOnlyCheckBox
        Left = 197
        Top = 0
        Width = 49
        Height = 16
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Offert'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 6
      end
      object cbDedicace: TReadOnlyCheckBox
        Left = 183
        Top = 33
        Width = 63
        Height = 16
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'D'#233'dicac'#233
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 7
      end
    end
    object lvEditions: TListBox
      Left = 346
      Top = 467
      Width = 170
      Height = 62
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clWhite
      ItemHeight = 13
      TabOrder = 8
      OnClick = lvEditionsClick
    end
  end
  object Popup3: TPopupMenu
    Left = 304
    Top = 16
    object Informations1: TMenuItem
      Caption = '&Informations'
      object Emprunts1: TMenuItem
        Caption = 'Emprunts:'
      end
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object Adresse1: TMenuItem
      Caption = '&Adresse'
    end
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 420
    Top = 14
    object EmpruntApercu: TAction
      Tag = 1
      Category = 'Emprunts'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Imprimer1Click
    end
    object FicheApercu: TAction
      Tag = 1
      Category = 'Fiche'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Impression1Click
    end
    object CouvertureApercu: TAction
      Tag = 1
      Category = 'Couverture'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Imprimer2Click
    end
    object FicheImprime: TAction
      Tag = 2
      Category = 'Fiche'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Impression1Click
    end
    object EmpruntImprime: TAction
      Tag = 2
      Category = 'Emprunts'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Imprimer1Click
    end
    object CouvertureImprime: TAction
      Tag = 2
      Category = 'Couverture'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Imprimer2Click
    end
  end
  object MainMenu1: TMainMenu
    AutoMerge = True
    Images = Fond.boutons_32x32_hot
    Left = 336
    Top = 16
    object Fiche1: TMenuItem
      Caption = 'Fiche'
      GroupIndex = 1
      object Aperuavantimpression1: TMenuItem
        Action = FicheApercu
      end
      object Aperuavantimpression2: TMenuItem
        Action = FicheImprime
      end
    end
    object Couverture1: TMenuItem
      Caption = 'Image'
      GroupIndex = 1
      object Aperuavantimpression5: TMenuItem
        Action = CouvertureApercu
      end
      object Aperuavantimpression6: TMenuItem
        Action = CouvertureImprime
      end
    end
    object Emprunts2: TMenuItem
      Caption = 'Emprunts'
      GroupIndex = 1
      object Aperuavantimpression3: TMenuItem
        Action = EmpruntApercu
      end
      object Aperuavantimpression4: TMenuItem
        Action = EmpruntImprime
      end
    end
  end
end
