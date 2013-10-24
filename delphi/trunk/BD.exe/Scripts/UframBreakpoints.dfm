object framBreakpoints: TframBreakpoints
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object vstBreakpoints: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    BevelKind = bkTile
    BorderStyle = bsNone
    Header.AutoSizeIndex = 1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
    Header.Style = hsPlates
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnChecked = vstBreakpointsChecked
    OnGetText = vstBreakpointsGetText
    OnPaintText = vstBreakpointsPaintText
    OnInitNode = vstBreakpointsInitNode
    ExplicitLeft = -276
    ExplicitWidth = 596
    ExplicitHeight = 158
    Columns = <
      item
        Position = 0
        Width = 100
        WideText = 'Position'
      end
      item
        Position = 1
        Width = 216
        WideText = 'Fichier'
      end>
  end
end
