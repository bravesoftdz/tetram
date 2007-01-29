object FrmChoixDetailSerie: TFrmChoixDetailSerie
  Left = 540
  Top = 358
  BorderStyle = bsDialog
  Caption = 'S'#233'lectionner le niveau de d'#233'tail'
  ClientHeight = 116
  ClientWidth = 283
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LightComboCheck1: TLightComboCheck
    Left = 30
    Top = 15
    Width = 227
    Height = 19
    Checked = True
    Border = CCBflat
    DefaultValueChecked = -1
    PropertiesStored = True
    Transparent = True
    CheckVisible = False
    FillCaption = False
    CheckedCaptionBold = False
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
  object CheckBox1: TCheckBox
    Left = 32
    Top = 48
    Width = 209
    Height = 17
    Caption = 'Inclure Pr'#233'visions de sorties/Manquants'
    TabOrder = 0
  end
  inline Frame11: TFrame1
    Left = 0
    Top = 91
    Width = 283
    Height = 25
    Align = alBottom
    TabOrder = 1
    inherited btnOK: TBitBtn
      Left = 112
    end
    inherited btnAnnuler: TBitBtn
      Left = 200
    end
  end
end
