object framMessages: TframMessages
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object vstMessages: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    BevelKind = bkTile
    BorderStyle = bsNone
    Header.AutoSizeIndex = 3
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
    Header.Style = hsPlates
    TabOrder = 0
    TreeOptions.PaintOptions = [toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnGetText = vstMessagesGetText
    ExplicitLeft = -276
    ExplicitWidth = 596
    ExplicitHeight = 158
    Columns = <
      item
        Position = 0
        Width = 100
        WideText = 'Contexte'
      end
      item
        Position = 1
        Width = 120
        WideText = 'Type'
      end
      item
        Position = 2
        Width = 150
        WideText = 'Fichier'
      end
      item
        Position = 3
        Width = 10
        WideText = 'Message'
      end>
  end
end
