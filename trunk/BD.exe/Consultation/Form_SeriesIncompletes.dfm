object frmSeriesIncompletes: TfrmSeriesIncompletes
  Left = 414
  Top = 463
  Width = 822
  Height = 275
  Caption = 'S'#233'ries incompl'#232'tes'
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
  object vstAlbumsManquants: TVirtualStringTree
    Left = 0
    Top = 25
    Width = 814
    Height = 204
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
    Header.Style = hsPlates
    HotCursor = crHandPoint
    Images = Fond.ImageList1
    TabOrder = 0
    OnFreeNode = vstAlbumsManquantsFreeNode
    OnGetText = vstAlbumsManquantsGetText
    OnInitNode = vstAlbumsManquantsInitNode
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
        WideText = 'Albums manquants'
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 814
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object CheckBox1: TCheckBox
      Left = 8
      Top = 4
      Width = 153
      Height = 17
      Caption = 'Tenir compte des int'#233'grales'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 176
      Top = 4
      Width = 193
      Height = 17
      Caption = 'Tenir compte des pr'#233'visions d'#39'achat'
      TabOrder = 1
      OnClick = CheckBox1Click
    end
  end
  object ActionList1: TActionList
    Left = 192
    Top = 40
    object ListeApercu: TAction
      Tag = 1
      Category = 'Liste'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = ListeApercuExecute
    end
    object ListeImprime: TAction
      Tag = 2
      Category = 'Liste'
      Caption = 'Imprimer'
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
