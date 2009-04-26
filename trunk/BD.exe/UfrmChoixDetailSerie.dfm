object frmChoixDetailSerie: TfrmChoixDetailSerie
  Left = 540
  Top = 358
  BorderStyle = bsDialog
  Caption = 'S'#233'lectionner le niveau de d'#233'tail'
  ClientHeight = 250
  ClientWidth = 387
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 221
    Width = 387
    Height = 29
    Align = alBottom
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    TabOrder = 1
    ExplicitLeft = -114
    ExplicitTop = 220
    inherited btnOK: TButton
      Left = 224
      Visible = False
    end
    inherited btnAnnuler: TButton
      Left = 304
    end
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 197
    Width = 209
    Height = 17
    Caption = 'Inclure Pr'#233'visions de sorties/Manquants'
    TabOrder = 0
  end
end
