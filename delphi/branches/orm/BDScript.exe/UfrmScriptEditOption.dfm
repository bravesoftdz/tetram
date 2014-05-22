object frmScriptEditOption: TfrmScriptEditOption
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Option'
  ClientHeight = 229
  ClientWidth = 319
  Color = clBtnFace
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
  object Label2: TLabel
    Left = 8
    Top = 46
    Width = 88
    Height = 13
    Caption = 'Valeurs possibles :'
  end
  object Label1: TLabel
    Left = 8
    Top = 19
    Width = 28
    Height = 13
    Caption = 'Nom :'
  end
  object Label3: TLabel
    Left = 8
    Top = 158
    Width = 91
    Height = 13
    Caption = 'Valeur par d'#233'faut :'
  end
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 200
    Width = 319
    Height = 29
    Align = alBottom
    TabOrder = 3
    ExplicitTop = 200
    ExplicitWidth = 319
    inherited btnOK: TButton
      Left = 156
      Enabled = False
      ExplicitLeft = 156
    end
    inherited btnAnnuler: TButton
      Left = 236
      ExplicitLeft = 236
    end
  end
  object MemoLabeled1: TMemoLabeled
    Left = 64
    Top = 65
    Width = 247
    Height = 87
    BevelKind = bkTile
    BorderStyle = bsNone
    TabOrder = 1
    OnChange = MemoLabeled1Change
    LinkControls = <
      item
        Control = Label2
      end>
  end
  object EditLabeled1: TEditLabeled
    Left = 64
    Top = 16
    Width = 247
    Height = 21
    BevelKind = bkTile
    BorderStyle = bsNone
    MaxLength = 50
    TabOrder = 0
    OnChange = MemoLabeled1Change
    LinkControls = <
      item
        Control = Label1
      end>
    CurrencyChar = #0
  end
  object EditLabeled2: TEditLabeled
    Left = 64
    Top = 177
    Width = 247
    Height = 21
    BevelKind = bkTile
    BorderStyle = bsNone
    MaxLength = 50
    TabOrder = 2
    OnChange = MemoLabeled1Change
    LinkControls = <
      item
        Control = Label3
      end>
    CurrencyChar = #0
  end
end
