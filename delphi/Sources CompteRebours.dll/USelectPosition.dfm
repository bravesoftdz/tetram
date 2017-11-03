object Form1: TForm1
  Left = 470
  Top = 364
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Coordonn'#233'es g'#233'ographiques'
  ClientHeight = 245
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 104
    Top = 4
    Width = 41
    Height = 13
    Caption = 'R'#233'gion'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 0
    Top = 44
    Width = 31
    Height = 13
    Caption = 'Villes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ComboBox1: TComboBox
    Left = 152
    Top = 0
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object ListView1: TListView
    Left = 0
    Top = 60
    Width = 441
    Height = 150
    Columns = <
      item
        Width = 150
      end
      item
        Width = 150
      end
      item
        Caption = 'Latitude'
        Width = 60
      end
      item
        Caption = 'Longitude'
        Width = 60
      end>
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = ListView1ColumnClick
    OnCompare = ListView1Compare
  end
  object Button1: TButton
    Left = 286
    Top = 220
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 366
    Top = 220
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 3
  end
end
