object framConvertisseur: TframConvertisseur
  Left = 0
  Top = 0
  Width = 451
  Height = 22
  Align = alTop
  TabOrder = 0
  object Label2: TLabel
    Left = 126
    Top = 6
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label1: TLabel
    Left = 80
    Top = 5
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label4: TLabel
    Left = 112
    Top = 6
    Width = 8
    Height = 13
    Caption = '='
  end
  object Edit1: TEditLabeled
    Left = 2
    Top = 2
    Width = 71
    Height = 19
    BevelKind = bkTile
    BorderStyle = bsNone
    TabOrder = 0
    OnChange = Edit1Change
    OnKeyPress = Edit1KeyPress
    LinkControls = <
      item
        Control = Label4
      end
      item
        Control = Label2
      end
      item
        Control = Label1
      end>
    TypeDonnee = tdNumeric
    CurrencyChar = #0
  end
end
