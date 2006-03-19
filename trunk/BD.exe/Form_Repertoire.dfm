object FrmRepertoire: TFrmRepertoire
  Left = 1869
  Top = 205
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'R'#233'pertoire'
  ClientHeight = 401
  ClientWidth = 345
  Color = clBtnFace
  Constraints.MinWidth = 250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageRep: TPageControl
    Left = 0
    Top = 0
    Width = 345
    Height = 401
    Cursor = crHandPoint
    ActivePage = TabParaBD
    Align = alClient
    HotTrack = True
    TabOrder = 0
    TabStop = False
    object TabAlbums: TTabSheet
      Caption = 'Albums'
      DesignSize = (
        337
        373)
      object LightComboCheck1: TLightComboCheck
        Left = 70
        Top = 23
        Width = 140
        Height = 19
        Checked = True
        Border = CCBflat
        DefaultValueChecked = -1
        PropertiesStored = True
        Transparent = True
        CheckVisible = False
        FillCaption = False
        CheckedCaptionBold = False
        OnChange = LightComboCheck1Change
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <
          item
            Valeur = 0
            Caption = 'Titre'
            Visible = True
            Enabled = True
            SubItems.CaptionComplet = True
            SubItems.Separateur = ' '
            SubItems = <>
          end
          item
            Valeur = 1
            Caption = 'S'#233'rie'
            Visible = True
            Enabled = True
            SubItems.CaptionComplet = True
            SubItems.Separateur = ' '
            SubItems = <>
          end
          item
            Valeur = 2
            Caption = 'Editeur'
            Visible = True
            Enabled = True
            SubItems.CaptionComplet = True
            SubItems.Separateur = ' '
            SubItems = <>
          end
          item
            Valeur = 3
            Caption = 'Genre'
            Visible = True
            Enabled = True
            SubItems.CaptionComplet = True
            SubItems.Separateur = ' '
            SubItems = <>
          end
          item
            Valeur = 4
            Caption = 'Ann'#233'e de parution'
            Visible = True
            Enabled = True
            SubItems.CaptionComplet = True
            SubItems.Separateur = ' '
            SubItems = <>
          end
          item
            Valeur = 5
            Caption = 'Collection'
            Visible = True
            Enabled = True
            SubItems.CaptionComplet = True
            SubItems.Separateur = ' '
            SubItems = <>
          end>
      end
      object Label1: TLabel
        Left = 4
        Top = 26
        Width = 61
        Height = 13
        Caption = 'Grouper par '
        Transparent = True
      end
      object VDTButton1: TVDTButton
        Left = 315
        Top = 2
        Width = 20
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = '...'
        Flat = True
        OnClick = VDTButton1Click
      end
      object vstAlbums: TVirtualStringTree
        Left = 2
        Top = 45
        Width = 333
        Height = 327
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
        TabOrder = 0
        OnDblClick = vstAlbumsDblClick
        Columns = <
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
            Position = 0
            Width = 333
          end>
      end
      object ScanEditAlbum: TEdit
        Left = 2
        Top = 2
        Width = 312
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
        OnChange = VDTButton1Click
        OnKeyPress = ScanEditAlbumKeyPress
      end
    end
    object TabEmprunteurs: TTabSheet
      Caption = 'Emprunteurs'
      DesignSize = (
        337
        373)
      object VDTButton2: TVDTButton
        Left = 315
        Top = 2
        Width = 20
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = '...'
        Flat = True
        OnClick = VDTButton2Click
      end
      object vstEmprunteurs: TVirtualStringTree
        Left = 2
        Top = 25
        Width = 333
        Height = 347
        Anchors = [akLeft, akTop, akRight, akBottom]
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
        Indent = 8
        TabOrder = 0
        OnDblClick = vstAlbumsDblClick
        Columns = <>
      end
      object ScanEditEmprunteur: TEdit
        Left = 2
        Top = 2
        Width = 312
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
        OnChange = VDTButton2Click
        OnKeyPress = ScanEditEmprunteurKeyPress
      end
    end
    object TabAuteurs: TTabSheet
      Caption = 'Auteurs'
      ImageIndex = 2
      DesignSize = (
        337
        373)
      object VDTButton3: TVDTButton
        Left = 315
        Top = 2
        Width = 20
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = '...'
        Flat = True
        OnClick = VDTButton3Click
      end
      object vstAuteurs: TVirtualStringTree
        Left = 2
        Top = 25
        Width = 333
        Height = 347
        Anchors = [akLeft, akTop, akRight, akBottom]
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
        Indent = 8
        TabOrder = 0
        OnDblClick = vstAlbumsDblClick
        Columns = <>
      end
      object ScanEditAuteur: TEdit
        Left = 2
        Top = 2
        Width = 312
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
        OnChange = VDTButton3Click
        OnKeyPress = ScanEditAuteurKeyPress
      end
    end
    object TabSeries: TTabSheet
      Caption = 'S'#233'ries'
      ImageIndex = 3
      DesignSize = (
        337
        373)
      object VDTButton5: TVDTButton
        Left = 315
        Top = 2
        Width = 20
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = '...'
        Flat = True
        OnClick = VDTButton5Click
      end
      object ScanEditSerie: TEdit
        Left = 2
        Top = 2
        Width = 312
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        OnChange = VDTButton3Click
        OnClick = VDTButton5Click
        OnKeyPress = ScanEditSerieKeyPress
      end
      object vstSeries: TVirtualStringTree
        Left = 2
        Top = 25
        Width = 333
        Height = 347
        Anchors = [akLeft, akTop, akRight, akBottom]
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
        Indent = 8
        TabOrder = 1
        OnDblClick = vstAlbumsDblClick
        Columns = <>
      end
    end
    object TabParaBD: TTabSheet
      Caption = 'Para-BD'
      ImageIndex = 4
      DesignSize = (
        337
        373)
      object VDTButton4: TVDTButton
        Left = 315
        Top = 2
        Width = 20
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = '...'
        Flat = True
        OnClick = VDTButton4Click
      end
      object ScanEditParaBD: TEdit
        Left = 2
        Top = 2
        Width = 312
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        OnChange = VDTButton3Click
        OnClick = VDTButton4Click
        OnKeyPress = ScanEditParaBDKeyPress
      end
      object vstParaBD: TVirtualStringTree
        Left = 2
        Top = 25
        Width = 333
        Height = 347
        Anchors = [akLeft, akTop, akRight, akBottom]
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
        Indent = 8
        TabOrder = 1
        OnDblClick = vstAlbumsDblClick
        Columns = <>
      end
    end
  end
end
