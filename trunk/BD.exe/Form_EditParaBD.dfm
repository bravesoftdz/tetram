object FrmEditParaBD: TFrmEditParaBD
  Left = 422
  Top = 70
  Width = 835
  Height = 926
  Caption = 'FrmEditParaBD'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 827
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    DesignSize = (
      827
      23)
    object btnOK: TBitBtn
      Left = 664
      Top = 2
      Width = 74
      Height = 19
      Cursor = crHandPoint
      Anchors = [akRight, akBottom]
      Caption = 'Enregistrer'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnAnnuler: TBitBtn
      Left = 745
      Top = 2
      Width = 72
      Height = 19
      Cursor = crHandPoint
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Annuler'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 23
    Width = 827
    Height = 871
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    DesignSize = (
      827
      871)
    object Label2: TLabel
      Left = 35
      Top = 7
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = ' Titre:'
      FocusControl = edTitre
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 6
      Top = 50
      Width = 56
      Height = 13
      Alignment = taRightJustify
      Caption = 'Description:'
      FocusControl = description
    end
    object btCreateur: TVDTButton
      Tag = 1
      Left = 248
      Top = 196
      Width = 57
      Height = 72
      Cursor = crHandPoint
      Caption = 'Auteur/Cr'#233'ateur'
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
    end
    object Label19: TLabel
      Left = 23
      Top = 177
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Auteurs:'
    end
    object Bevel1: TBevel
      Left = 0
      Top = 867
      Width = 827
      Height = 4
      Align = alBottom
      Shape = bsSpacer
    end
    object Label20: TLabel
      Left = 35
      Top = 285
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie:'
    end
    object Bevel3: TBevel
      Left = 139
      Top = 166
      Width = 293
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Bevel4: TBevel
      Left = 139
      Top = 397
      Width = 293
      Height = 7
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Bevel5: TBevel
      Left = 139
      Top = 273
      Width = 293
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label24: TLabel
      Left = 58
      Top = 484
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ann'#233'e:'
      Layout = tlCenter
    end
    object Label25: TLabel
      Left = 147
      Top = 484
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'Cote:'
      Layout = tlCenter
    end
    object VDTButton14: TVDTButton
      Left = 242
      Top = 480
      Width = 72
      Height = 21
      Cursor = crHandPoint
      Caption = 'Convertisseur'
      Flat = True
      OnClick = VDTButton14Click
    end
    object Label10: TLabel
      Left = 28
      Top = 31
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ann'#233'e:'
      Layout = tlCenter
    end
    object Label18: TLabel
      Left = 163
      Top = 420
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = 'Achet'#233' le:'
      Layout = tlCenter
    end
    object Label9: TLabel
      Left = 151
      Top = 444
      Width = 20
      Height = 13
      Alignment = taRightJustify
      Caption = 'Prix:'
      Layout = tlCenter
    end
    object SpeedButton3: TVDTButton
      Left = 241
      Top = 440
      Width = 72
      Height = 21
      Cursor = crHandPoint
      Caption = 'Convertisseur'
      Flat = True
      OnClick = SpeedButton3Click
    end
    object Label12: TLabel
      Left = 121
      Top = 31
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = 'Type:'
      Layout = tlCenter
    end
    object cbxType: TLightComboCheck
      Left = 148
      Top = 31
      Width = 166
      Height = 13
      Checked = False
      PropertiesStored = False
      CheckVisible = False
      ShowCaptionHint = False
      AssignHint = False
      OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
      Items.CaptionComplet = True
      Items.Separateur = ' '
      Items = <>
    end
    object edTitre: TEditLabeled
      Left = 64
      Top = 4
      Width = 442
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      LinkLabel.LinkLabel.Strings = (
        'Label2')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = Label2
        end>
      CurrencyChar = #0
    end
    object description: TMemoLabeled
      Left = 64
      Top = 50
      Width = 442
      Height = 111
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 1
      LinkLabel.LinkLabel.Strings = (
        'Label6')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = Label6
        end>
    end
    object lvAuteurs: TVDTListViewLabeled
      Left = 305
      Top = 196
      Width = 201
      Height = 72
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      Columns = <
        item
          Width = 46
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      SortType = stNone
      TabOrder = 3
      ViewStyle = vsReport
      LinkLabel.LinkLabel.Strings = (
        'btScenariste')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = btCreateur
        end>
    end
    object vtPersonnes: TVirtualStringTree
      Left = 64
      Top = 196
      Width = 177
      Height = 72
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
      TabOrder = 2
      Columns = <>
    end
    object vtSeries: TVirtualStringTree
      Left = 64
      Top = 304
      Width = 442
      Height = 88
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
      TabOrder = 4
      Columns = <>
    end
    object edAnneeCote: TEditLabeled
      Left = 94
      Top = 480
      Width = 46
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 4
      TabOrder = 5
      LinkLabel.LinkLabel.Strings = (
        'Label24')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = Label24
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object edPrixCote: TEditLabeled
      Left = 175
      Top = 480
      Width = 64
      Height = 21
      AutoSelect = False
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 6
      LinkLabel.LinkLabel.Strings = (
        'Label25'
        'VDTButton14')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = Label25
        end
        item
          Control = VDTButton14
        end>
      TypeDonnee = tdCurrency
      CurrencyChar = #0
    end
    object edAnneeEdition: TEditLabeled
      Left = 64
      Top = 27
      Width = 46
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 4
      TabOrder = 7
      LinkLabel.LinkLabel.Strings = (
        'Label10')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = Label10
        end>
      TypeDonnee = tdEntier
      CurrencyChar = #0
    end
    object cbStock: TCheckBoxLabeled
      Left = 445
      Top = 420
      Width = 61
      Height = 13
      Caption = 'En stock'
      Checked = True
      Ctl3D = True
      ParentCtl3D = False
      State = cbChecked
      TabOrder = 8
      LinkLabel.LinkLabel.Strings = (
        'cbStock')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = cbStock
        end>
    end
    object cbGratuit: TCheckBoxLabeled
      Left = 69
      Top = 442
      Width = 53
      Height = 16
      Cursor = crHandPoint
      Caption = 'Gratuit'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 9
      OnClick = cbGratuitClick
      LinkLabel.LinkLabel.Strings = (
        'cbVO')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = cbGratuit
        end>
    end
    object cbOffert: TCheckBoxLabeled
      Left = 69
      Top = 418
      Width = 53
      Height = 16
      Cursor = crHandPoint
      Caption = 'Offert'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 10
      OnClick = cbOffertClick
      LinkLabel.LinkLabel.Strings = (
        'cbVO')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = cbOffert
        end>
    end
    object dtpAchat: TDateTimePickerLabeled
      Left = 213
      Top = 416
      Width = 101
      Height = 21
      Date = 38158.758085983800000000
      Time = 38158.758085983800000000
      ShowCheckbox = True
      Checked = False
      TabOrder = 11
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = Label18
        end>
    end
    object edPrix: TEditLabeled
      Left = 174
      Top = 440
      Width = 64
      Height = 21
      AutoSelect = False
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 12
      OnChange = edPrixChange
      LinkLabel.LinkLabel.Strings = (
        'Label9'
        'SpeedButton3')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = Label9
        end
        item
          Control = SpeedButton3
        end>
      TypeDonnee = tdCurrency
      CurrencyChar = #0
    end
    object cbDedicace: TCheckBoxLabeled
      Left = 334
      Top = 29
      Width = 64
      Height = 16
      Cursor = crHandPoint
      Caption = 'D'#233'dicac'#233
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 13
      LinkLabel.LinkLabel.Strings = (
        'cbDedicace')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = cbDedicace
        end>
    end
    object Panel1: TPanel
      Left = 513
      Top = 4
      Width = 305
      Height = 501
      Anchors = [akTop, akRight]
      BevelInner = bvLowered
      Caption = ' '
      TabOrder = 14
      object imgVisu: TImage
        Left = 2
        Top = 2
        Width = 301
        Height = 446
        Cursor = crHandPoint
        Align = alClient
        Center = True
      end
      object Panel3: TPanel
        Left = 2
        Top = 448
        Width = 301
        Height = 51
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        object ChoixImage: TVDTButton
          Tag = 1
          Left = 180
          Top = 5
          Width = 117
          Height = 41
          Cursor = crHandPoint
          Caption = 'Image'
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033BBBBBBBBBB
            BB33337777777777777F33BB00BBBBBBBB33337F77333333F37F33BB0BBBBBB0
            BB33337F73F33337FF7F33BBB0BBBB000B33337F37FF3377737F33BBB00BB00B
            BB33337F377F3773337F33BBBB0B00BBBB33337F337F7733337F33BBBB000BBB
            BB33337F33777F33337F33EEEE000EEEEE33337F3F777FFF337F33EE0E80000E
            EE33337F73F77773337F33EEE0800EEEEE33337F37377F33337F33EEEE000EEE
            EE33337F33777F33337F33EEEEE00EEEEE33337F33377FF3337F33EEEEEE00EE
            EE33337F333377F3337F33EEEEEE00EEEE33337F33337733337F33EEEEEEEEEE
            EE33337FFFFFFFFFFF7F33EEEEEEEEEEEE333377777777777773}
          NumGlyphs = 2
        end
      end
    end
    object cbNumerote: TCheckBoxLabeled
      Left = 422
      Top = 29
      Width = 64
      Height = 16
      Cursor = crHandPoint
      Caption = 'Num'#233'rot'#233
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 15
      LinkLabel.LinkLabel.Strings = (
        'cbDedicace')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = cbNumerote
        end>
    end
    inline FrameRechercheRapideSerie: TFrameRechercheRapide
      Left = 64
      Top = 281
      Width = 442
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 16
      inherited btNext: TVDTButton
        Left = 401
      end
      inherited btNew: TVDTButton
        Left = 421
      end
      inherited edSearch: TEditLabeled
        Width = 402
        LinkControls = <
          item
            Control = Label20
          end>
      end
    end
    inline FrameRechercheRapideAuteur: TFrameRechercheRapide
      Left = 64
      Top = 173
      Width = 177
      Height = 21
      TabOrder = 17
      inherited btNext: TVDTButton
        Left = 136
      end
      inherited btNew: TVDTButton
        Left = 156
      end
      inherited edSearch: TEditLabeled
        Width = 137
        LinkControls = <
          item
            Control = Label19
          end>
      end
    end
  end
end
