object framScriptInfos: TframScriptInfos
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object Panel3: TPageControl
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    ActivePage = TabSheet4
    Align = alClient
    TabOrder = 0
    object TabSheet4: TTabSheet
      Caption = 'Options'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ListBox1: TListBox
        Left = 0
        Top = 0
        Width = 312
        Height = 212
        Style = lbVirtual
        Align = alClient
        BevelKind = bkTile
        BorderStyle = bsNone
        PopupMenu = PopupMenu2
        TabOrder = 0
        OnData = ListBox1Data
        OnDblClick = ListBox1DblClick
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Informations'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label11: TLabel
        Left = 3
        Top = 6
        Width = 45
        Height = 13
        Caption = 'Auteur :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 3
        Top = 33
        Width = 48
        Height = 13
        Caption = 'Version :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 3
        Top = 60
        Width = 123
        Height = 13
        Caption = 'Version de BDth'#232'que :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 3
        Top = 87
        Width = 70
        Height = 13
        Caption = 'Description :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EditLabeled1: TEditLabeled
        Left = 79
        Top = 3
        Width = 177
        Height = 21
        TabOrder = 0
        Text = 'EditLabeled1'
        OnChange = MemoLabeled1Change
        LinkControls = <
          item
            Control = Label11
          end>
        CurrencyChar = #0
      end
      object MemoLabeled1: TMemoLabeled
        Left = 79
        Top = 84
        Width = 177
        Height = 71
        Lines.Strings = (
          'MemoLabeled1')
        TabOrder = 3
        OnChange = MemoLabeled1Change
        LinkControls = <
          item
            Control = Label14
          end>
      end
      object EditLabeled2: TEditLabeled
        Left = 79
        Top = 30
        Width = 177
        Height = 21
        TabOrder = 1
        Text = 'EditLabeled1'
        OnChange = MemoLabeled1Change
        LinkControls = <
          item
            Control = Label12
          end>
        CurrencyChar = #0
      end
      object EditLabeled3: TEditLabeled
        Left = 132
        Top = 57
        Width = 124
        Height = 21
        TabOrder = 2
        Text = 'EditLabeled1'
        OnChange = MemoLabeled1Change
        LinkControls = <
          item
            Control = Label13
          end>
        CurrencyChar = #0
      end
    end
    object Alias: TTabSheet
      Caption = 'Alias'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Memo2: TMemo
        Left = 3
        Top = 3
        Width = 253
        Height = 152
        Lines.Strings = (
          'Memo2')
        TabOrder = 0
        OnChange = MemoLabeled1Change
      end
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 28
    Top = 32
    object Creruneoption1: TMenuItem
      Action = actCreerOption
    end
    object Modifieruneoption1: TMenuItem
      Action = actModifierOption
    end
    object Retireruneoption1: TMenuItem
      Action = actRetirerOption
    end
  end
  object ActionList1: TActionList
    Images = frmFond.boutons_32x32_hot
    OnUpdate = ActionList1Update
    Left = 124
    Top = 32
    object actCreerOption: TAction
      Category = 'Script'
      Caption = 'Cr'#233'er une option'
      OnExecute = actCreerOptionExecute
    end
    object actRetirerOption: TAction
      Category = 'Script'
      Caption = 'Retirer une option'
      OnExecute = actRetirerOptionExecute
    end
    object actModifierOption: TAction
      Category = 'Script'
      Caption = 'Modifier une option'
      OnExecute = actModifierOptionExecute
    end
  end
end
