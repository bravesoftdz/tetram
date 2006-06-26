object frmPrevisionsSorties: TfrmPrevisionsSorties
  Left = 379
  Top = 471
  Width = 822
  Height = 384
  Caption = 'Previsions de sorties'
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
    Height = 306
    Align = alClient
    AnimationDuration = 0
    BevelKind = bkTile
    BorderStyle = bsNone
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Images = Fond.ImageList1
    Header.Options = [hoAutoResize, hoColumnResize, hoShowImages, hoVisible]
    Header.SortColumn = 1
    Header.Style = hsPlates
    HotCursor = crHandPoint
    Images = Fond.ImageList1
    TabOrder = 0
    OnAfterItemPaint = vstPrevisionsSortiesAfterItemPaint
    OnFreeNode = vstPrevisionsSortiesFreeNode
    OnGetText = vstPrevisionsSortiesGetText
    OnInitNode = vstPrevisionsSortiesInitNode
    OnResize = vstPrevisionsSortiesResize
    Columns = <
      item
        Position = 0
        Width = 250
        WideText = 'Serie'
      end
      item
        MinWidth = 50
        Position = 1
        Width = 560
        WideText = 'Pr'#233'visions'
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
      Cursor = crHandPoint
      Caption = '...'
      Flat = True
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
end
