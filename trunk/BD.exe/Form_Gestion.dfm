object FrmGestions: TFrmGestions
  Left = 414
  Top = 314
  BorderIcons = [biMinimize]
  BorderStyle = bsSingle
  Caption = 'FrmGestions'
  ClientHeight = 345
  ClientWidth = 644
  Color = clBtnFace
  Constraints.MinHeight = 230
  Constraints.MinWidth = 485
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    644
    345)
  PixelsPerInch = 96
  TextHeight = 13
  object VDTButton1: TVDTButton
    Left = 452
    Top = 41
    Width = 21
    Height = 18
    Cursor = crHandPoint
    Caption = '...'
    Flat = True
    OnClick = VDTButton1Click
  end
  object Panel3: TPanel
    Left = 104
    Top = 0
    Width = 540
    Height = 38
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    ParentBackground = True
    TabOrder = 2
    object VDTButton2: TVDTButton
      Left = 5
      Top = 7
      Width = 88
      Height = 25
      Cursor = crHandPoint
      Hint = 'Ajouter un genre'
      Caption = 'Rafra'#238'chir'
      Flat = True
      OnClick = VDTButton2Click
    end
    object Bevel4: TBevel
      Left = 97
      Top = 7
      Width = 8
      Height = 22
      Shape = bsLeftLine
    end
    object ajouter: TVDTButton
      Left = 101
      Top = 7
      Width = 88
      Height = 25
      Cursor = crHandPoint
      Hint = 'Ajouter un genre'
      Caption = 'Nouveau'
      Flat = True
      OnClick = ajouterClick
    end
    object modifier: TVDTButton
      Left = 190
      Top = 7
      Width = 89
      Height = 25
      Cursor = crHandPoint
      Hint = 'Modifier le genre s'#233'lectionn'#233
      Caption = 'Modifier'
      Flat = True
      OnClick = modifierClick
    end
    object supprimer: TVDTButton
      Left = 280
      Top = 7
      Width = 88
      Height = 25
      Cursor = crHandPoint
      Hint = 'Supprimer le genre s'#233'lectionn'#233
      Caption = 'Supprimer'
      Flat = True
      OnClick = supprimerClick
    end
    object Bevel7: TBevel
      Left = 372
      Top = 7
      Width = 6
      Height = 22
      Shape = bsLeftLine
    end
    object acheter: TVDTButton
      Left = 377
      Top = 7
      Width = 88
      Height = 25
      Cursor = crHandPoint
      Hint = 'Ajouter un genre'
      Caption = 'Acheter'
      Flat = True
      Visible = False
      OnClick = acheterClick
    end
  end
  object VirtualTreeView: TVirtualStringTree
    Left = 105
    Top = 62
    Width = 537
    Height = 281
    Anchors = [akLeft, akTop, akRight, akBottom]
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
    Header.Options = [hoColumnResize, hoDrag]
    HintAnimation = hatNone
    HintMode = hmTooltip
    HotCursor = crHandPoint
    Indent = 8
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    OnDblClick = modifierClick
    Columns = <
      item
        Position = 0
      end
      item
        Position = 1
      end
      item
        Position = 2
      end
      item
        Position = 3
      end>
  end
  object Panel14: TPanel
    Left = 0
    Top = 0
    Width = 104
    Height = 345
    Anchors = [akLeft, akTop, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    ParentBackground = True
    TabOrder = 1
    DesignSize = (
      104
      345)
    object btAlbums: TVDTButton
      Left = 5
      Top = 7
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'Albums'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object btEditeurs: TVDTButton
      Left = 5
      Top = 131
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'Editeurs'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object btAuteurs: TVDTButton
      Left = 5
      Top = 98
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'Auteurs'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object btGenre: TVDTButton
      Left = 5
      Top = 189
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'Genres'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object btCollections: TVDTButton
      Left = 5
      Top = 156
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'Collections'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object btSeries: TVDTButton
      Left = 5
      Top = 65
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'S'#233'ries'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object Bevel1: TBevel
      Left = 19
      Top = 125
      Width = 65
      Height = 3
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
    end
    object Bevel3: TBevel
      Left = 19
      Top = 183
      Width = 65
      Height = 3
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
    end
    object Bevel2: TBevel
      Left = 19
      Top = 58
      Width = 65
      Height = 4
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
    end
    object Bevel5: TBevel
      Left = 19
      Top = 273
      Width = 65
      Height = 4
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
    end
    object btAchatsAlbums: TVDTButton
      Left = 5
      Top = 32
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'Achats'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object Bevel6: TBevel
      Left = 19
      Top = 92
      Width = 65
      Height = 3
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
    end
    object Bevel8: TBevel
      Left = 19
      Top = 215
      Width = 65
      Height = 4
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
    end
    object btParaBD: TVDTButton
      Left = 5
      Top = 222
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'Para-BD'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object btAchatsParaBD: TVDTButton
      Left = 5
      Top = 247
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'Achats'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object btEmprunteurs: TVDTButton
      Left = 5
      Top = 280
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'Emprunteurs'
      Flat = True
      OnClick = SpeedButton1Click
    end
  end
  object ScanEdit: TEdit
    Left = 105
    Top = 41
    Width = 345
    Height = 18
    BevelKind = bkTile
    BorderStyle = bsNone
    TabOrder = 3
    OnChange = VDTButton1Click
    OnKeyPress = ScanEditKeyPress
  end
end
