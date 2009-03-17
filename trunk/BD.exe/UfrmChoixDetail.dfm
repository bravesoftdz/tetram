object frmChoixDetail: TfrmChoixDetail
  Left = 559
  Top = 309
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'Gestion BDth'#232'que'
  ClientHeight = 185
  ClientWidth = 112
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 112
    Height = 150
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 0
    Top = 152
    Width = 112
    Height = 33
    Shape = bsFrame
  end
  object BtnChoix1: TButton
    Left = 15
    Top = 5
    Width = 83
    Height = 23
    Cursor = crHandPoint
    Caption = 'BtnChoix1'
    ModalResult = 6
    TabOrder = 0
  end
  object BtnChoix2: TButton
    Left = 15
    Top = 42
    Width = 83
    Height = 23
    Cursor = crHandPoint
    Caption = 'BtnChoix2'
    ModalResult = 7
    TabOrder = 1
  end
  object BtnAnnuler: TButton
    Left = 15
    Top = 157
    Width = 83
    Height = 23
    Cursor = crHandPoint
    Hint = 'Annule l'#39'action demand'#233'e'
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 7
  end
  object cbDessins: TCheckBox
    Left = 30
    Top = 82
    Width = 75
    Height = 16
    Caption = 'Dessins'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object cbHistoire: TCheckBox
    Left = 30
    Top = 111
    Width = 75
    Height = 16
    Caption = 'Histoire'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object cbNotes: TCheckBox
    Left = 30
    Top = 126
    Width = 75
    Height = 16
    Caption = 'Notes'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object cbScenario: TCheckBox
    Left = 30
    Top = 67
    Width = 75
    Height = 16
    Caption = 'Sc'#233'nario'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object cbCouleurs: TCheckBox
    Left = 30
    Top = 97
    Width = 75
    Height = 15
    Caption = 'Couleurs'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
