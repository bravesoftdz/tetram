object frmControlImport: TfrmControlImport
  Left = 0
  Top = 0
  Caption = 'Importation de donn'#233'e'
  ClientHeight = 159
  ClientWidth = 491
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 53
    Width = 89
    Height = 13
    Caption = 'Valeur r'#233'cup'#233'r'#233'e :'
  end
  object Label2: TLabel
    Left = 110
    Top = 53
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 475
    Height = 39
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 75
    Width = 96
    Height = 13
    Caption = 'El'#233'ment '#224' associer :'
  end
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 134
    Width = 491
    Height = 25
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 134
    ExplicitWidth = 491
    inherited btnOK: TButton
      Left = 328
      ExplicitLeft = 328
    end
    inherited btnAnnuler: TButton
      Left = 408
      ExplicitLeft = 408
    end
  end
  object CheckBox1: TCheckBox
    Left = 110
    Top = 99
    Width = 227
    Height = 17
    Caption = 'Ne plus poser la question pour cette valeur'
    TabOrder = 1
  end
  inline framVTEdit1: TframVTEdit
    Left = 110
    Top = 72
    Width = 373
    Height = 21
    TabOrder = 2
    ExplicitLeft = 110
    ExplicitTop = 72
    ExplicitWidth = 373
    inherited btReset: TVDTButton
      Left = 310
      ExplicitLeft = 310
    end
    inherited btNew: TVDTButton
      Left = 352
      OnClick = framVTEdit1btNewClick
      ExplicitLeft = 352
    end
    inherited btEdit: TVDTButton
      Left = 331
      OnClick = framVTEdit1btEditClick
      ExplicitLeft = 331
    end
    inherited VTEdit: TJvComboEdit
      Width = 310
      OnChange = framVTEdit1VTEditChange
      ExplicitWidth = 310
    end
  end
end
