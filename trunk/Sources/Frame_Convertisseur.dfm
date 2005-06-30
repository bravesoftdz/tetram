object Convertisseur: TConvertisseur
  Left = 0
  Top = 0
  Width = 443
  Height = 22
  Align = alTop
  TabOrder = 0
  object Label2: TLabel
    Left = 120
    Top = 5
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object Label1: TLabel
    Left = 80
    Top = 5
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label4: TLabel
    Left = 112
    Top = 5
    Width = 6
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
    LinkLabel.LinkLabel.Strings = (
      'Label1'
      'Label2'
      'Label4')
    TypeDonnee = tdNumeric
    CurrencyChar = #0
  end
end
