object framWatches: TframWatches
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object vstSuivis: TVirtualStringTree
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
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
    OnChecked = vstSuivisChecked
    OnEditing = vstSuivisEditing
    OnGetText = vstSuivisGetText
    OnPaintText = vstSuivisPaintText
    OnInitNode = vstSuivisInitNode
    OnNewText = vstSuivisNewText
    ExplicitLeft = -276
    ExplicitWidth = 596
    ExplicitHeight = 158
    Columns = <
      item
        Position = 0
        Width = 146
        WideText = 'Expression'
      end
      item
        Position = 1
        Width = 174
        WideText = 'Valeur'
      end>
  end
end
