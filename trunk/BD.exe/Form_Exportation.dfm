object FrmExportation: TFrmExportation
  Left = 440
  Top = 395
  Width = 800
  Height = 617
  Caption = 'Exportation'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    792
    585)
  PixelsPerInch = 96
  TextHeight = 13
  object VDTButton1: TVDTButton
    Left = 107
    Top = 237
    Width = 95
    Height = 24
    Cursor = crHandPoint
    Caption = 'Ajouter'
    Flat = True
    OnClick = VDTButton1Click
  end
  object VDTButton2: TVDTButton
    Left = 203
    Top = 237
    Width = 95
    Height = 24
    Cursor = crHandPoint
    Caption = 'Retirer'
    Flat = True
    OnClick = VDTButton2Click
  end
  object Panel14: TPanel
    Left = 1
    Top = 2
    Width = 104
    Height = 587
    Anchors = [akLeft, akTop, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    ParentBackground = True
    TabOrder = 0
    DesignSize = (
      104
      587)
    object VDTButton20: TVDTButton
      Left = 4
      Top = 2
      Width = 95
      Height = 24
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Fermer'
      Flat = True
      OnClick = VDTButton20Click
    end
    object VDTButton3: TVDTButton
      Left = 4
      Top = 50
      Width = 95
      Height = 24
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Exporter'
      Flat = True
      OnClick = VDTButton3Click
    end
    object VDTButton4: TVDTButton
      Left = 4
      Top = 74
      Width = 95
      Height = 24
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Tout exporter'
      Flat = True
      OnClick = VDTButton3Click
    end
  end
  object vstExportation: TVirtualStringTree
    Left = 107
    Top = 264
    Width = 682
    Height = 325
    Anchors = [akLeft, akTop, akRight, akBottom]
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
    TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
    OnFreeNode = vstExportationFreeNode
    OnGetText = vstExportationGetText
    OnPaintText = vstExportationPaintText
    Columns = <
      item
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        Width = 678
      end>
  end
  object vstAlbums: TVirtualStringTree
    Left = 107
    Top = 4
    Width = 682
    Height = 230
    Anchors = [akLeft, akTop, akRight]
    AnimationDuration = 0
    BackgroundOffsetY = 24
    BevelKind = bkTile
    BorderStyle = bsNone
    DragOperations = [doCopy]
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
    TabOrder = 2
    Columns = <
      item
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        Width = 678
      end>
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'xml'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 9
    Top = 82
  end
end
