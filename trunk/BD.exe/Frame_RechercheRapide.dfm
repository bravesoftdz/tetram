object FrameRechercheRapide: TFrameRechercheRapide
  Left = 0
  Top = 0
  Width = 291
  Height = 21
  TabOrder = 0
  DesignSize = (
    291
    21)
  object btNext: TVDTButton
    Left = 250
    Top = 0
    Width = 20
    Height = 20
    Cursor = crHandPoint
    Anchors = [akTop, akRight]
    Caption = '...'
    Flat = True
    OnClick = edSearchChange
  end
  object btNew: TVDTButton
    Left = 270
    Top = 0
    Width = 21
    Height = 20
    Cursor = crHandPoint
    Anchors = [akTop, akRight]
    Caption = 'N'
    Flat = True
    OnClick = btNewClick
  end
  object edSearch: TEditLabeled
    Left = 0
    Top = 0
    Width = 251
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BorderStyle = bsNone
    TabOrder = 0
    OnChange = edSearchChange
    OnKeyUp = edSearchKeyUp
    LinkControls = <>
    CurrencyChar = #0
  end
end
