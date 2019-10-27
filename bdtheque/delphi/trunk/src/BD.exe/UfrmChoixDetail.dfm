object frmChoixDetail: TfrmChoixDetail
  Left = 303
  Top = 190
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Gestion BDth'#232'que'
  ClientHeight = 216
  ClientWidth = 337
  Color = clWindow
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BtnChoix1: TButton
    Left = 22
    Top = 23
    Width = 291
    Height = 41
    Cursor = crHandPoint
    Caption = 'BtnChoix1'
    ModalResult = 6
    Style = bsCommandLink
    TabOrder = 0
  end
  object BtnChoix2: TButton
    Left = 22
    Top = 70
    Width = 291
    Height = 41
    Cursor = crHandPoint
    Caption = 'BtnChoix2'
    ModalResult = 7
    Style = bsCommandLink
    TabOrder = 1
  end
  object cbDessins: TCheckBox
    Left = 86
    Top = 132
    Width = 75
    Height = 16
    Caption = 'Dessins'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object cbHistoire: TCheckBox
    Left = 198
    Top = 117
    Width = 75
    Height = 16
    Caption = 'Histoire'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object cbNotes: TCheckBox
    Left = 198
    Top = 132
    Width = 75
    Height = 16
    Caption = 'Notes'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object cbScenario: TCheckBox
    Left = 86
    Top = 117
    Width = 75
    Height = 16
    Caption = 'Sc'#233'nario'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object cbCouleurs: TCheckBox
    Left = 86
    Top = 147
    Width = 75
    Height = 15
    Caption = 'Couleurs'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 187
    Width = 337
    Height = 29
    Align = alBottom
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    TabOrder = 7
    ExplicitTop = 187
    ExplicitWidth = 337
    inherited btnOK: TButton
      Left = 174
      Visible = False
      ExplicitLeft = 174
    end
    inherited btnAnnuler: TButton
      Left = 254
      ExplicitLeft = 254
    end
  end
end
