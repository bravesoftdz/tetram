object frmPrevisionsSorties: TfrmPrevisionsSorties
  Left = 379
  Top = 471
  Caption = 'Previsions de sorties'
  ClientHeight = 338
  ClientWidth = 814
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object vstPrevisionsSorties: TVirtualStringTree
    Left = 0
    Top = 26
    Width = 814
    Height = 312
    Align = alClient
    AnimationDuration = 0
    BevelKind = bkTile
    BorderStyle = bsNone
    Header.AutoSizeIndex = -1
    Header.DefaultHeight = 17
    Header.Height = 17
    Header.Images = frmFond.ImageList1
    Header.Options = [hoAutoResize, hoColumnResize, hoShowImages, hoVisible]
    Header.SortColumn = 1
    Header.Style = hsPlates
    HotCursor = crHandPoint
    Images = frmFond.ImageList1
    TabOrder = 0
    TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect, toRightClickSelect]
    OnAfterItemPaint = vstPrevisionsSortiesAfterItemPaint
    OnDblClick = vstPrevisionsSortiesDblClick
    OnFreeNode = vstPrevisionsSortiesFreeNode
    OnGetText = vstPrevisionsSortiesGetText
    OnPaintText = vstPrevisionsSortiesPaintText
    OnGetPopupMenu = vstPrevisionsSortiesGetPopupMenu
    OnInitNode = vstPrevisionsSortiesInitNode
    OnResize = vstPrevisionsSortiesResize
    Columns = <
      item
        Position = 0
        Text = 'S'#233'rie'
        Width = 250
      end
      item
        MinWidth = 50
        Position = 1
        Text = 'Pr'#233'visions'
        Width = 560
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 814
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object btNext: TVDTButton
      Left = 251
      Top = 4
      Width = 20
      Height = 20
      Caption = '...'
      Flat = False
      OnClick = edSearchChange
    end
    object CheckBox1: TCheckBox
      Left = 288
      Top = 5
      Width = 193
      Height = 17
      Caption = 'Tenir compte des pr'#233'visions d'#39'achat'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object edSearch: TEditLabeled
      Left = 1
      Top = 4
      Width = 251
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 1
      OnChange = edSearchChange
      OnKeyUp = edSearchKeyUp
      LinkControls = <>
      CurrencyChar = #0
    end
  end
  object ActionList1: TActionList
    Left = 192
    Top = 40
    object ListeApercu: TAction
      Tag = 1
      Category = 'Liste'
      Caption = '   &Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = ListeApercuExecute
    end
    object ListeImprime: TAction
      Tag = 2
      Category = 'Liste'
      Caption = '   &Imprimer'
      ImageIndex = 3
      OnExecute = ListeApercuExecute
    end
    object SeriePlusSuivie: TAction
      Category = 'PopupMenu'
      Caption = 'Ne plus surveiller les sorties'
      OnExecute = SeriePlusSuivieExecute
    end
    object SerieTerminee: TAction
      Category = 'PopupMenu'
      Caption = 'S'#233'rie termin'#233'e'
      OnExecute = SerieTermineeExecute
    end
    object EditSerie: TAction
      Category = 'PopupMenu'
      Caption = 'Modifier...'
      OnExecute = EditSerieExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 40
    object Liste1: TMenuItem
      Caption = 'Liste'
      object Aperuavantimpression1: TMenuItem
        Action = ListeApercu
      end
      object Imprimer1: TMenuItem
        Action = ListeImprime
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 304
    Top = 80
    object Neplussurveillerlessorties1: TMenuItem
      Action = SeriePlusSuivie
    end
    object Srietermine1: TMenuItem
      Action = SerieTerminee
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Modifier1: TMenuItem
      Action = EditSerie
    end
  end
end
