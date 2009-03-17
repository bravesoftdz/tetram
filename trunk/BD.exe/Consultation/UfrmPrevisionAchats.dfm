object frmPrevisionsAchats: TfrmPrevisionsAchats
  Left = 262
  Top = 208
  Caption = 'Achats pr'#233'vus'
  ClientHeight = 594
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object vstPrevisionsAchats: TVirtualStringTree
    Left = 0
    Top = 25
    Width = 862
    Height = 569
    Align = alClient
    BevelKind = bkTile
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HotCursor = crHandPoint
    ParentFont = False
    TabOrder = 0
    OnPaintText = vstPrevisionsAchatsPaintText
    Columns = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 862
    Height = 25
    Align = alTop
    Caption = ' '
    TabOrder = 1
    object Label1: TLabel
      Left = 4
      Top = 6
      Width = 61
      Height = 13
      Caption = 'Grouper par '
      Transparent = True
    end
    object LightComboCheck1: TLightComboCheck
      Left = 70
      Top = 3
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
