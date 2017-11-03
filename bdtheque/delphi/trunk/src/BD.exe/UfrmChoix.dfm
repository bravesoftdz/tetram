object frmChoix: TfrmChoix
  Left = 303
  Top = 190
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Gestion BDth'#232'que'
  ClientHeight = 164
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
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 135
    Width = 337
    Height = 29
    Align = alBottom
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    TabOrder = 2
    ExplicitTop = 154
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
