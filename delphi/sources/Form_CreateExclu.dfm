object FCreateExclu: TFCreateExclu
  Left = 334
  Top = 352
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'Exclusion'
  ClientHeight = 165
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 0
    Top = 72
    Width = 281
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 288
    Top = 72
    Width = 27
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 0
    Width = 209
    Height = 41
    Caption = 'M'#233'thode de recherche'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Processus'
      'Nom de fen'#234'tre')
    TabOrder = 2
    OnClick = RadioGroup1Click
  end
  object CheckBox1: TCheckBox
    Left = 216
    Top = 17
    Width = 97
    Height = 17
    Caption = 'Fen'#234'tres enfants'
    Enabled = False
    TabOrder = 3
  end
  object Button5: TButton
    Left = 160
    Top = 140
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object Button3: TButton
    Left = 240
    Top = 140
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 5
  end
  object OpenDialogExclu: TOpenDialog
    Top = 104
  end
end
