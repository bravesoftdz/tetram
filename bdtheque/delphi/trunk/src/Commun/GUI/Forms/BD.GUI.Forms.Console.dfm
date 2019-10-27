object frmConsole: TfrmConsole
  Left = 0
  Top = 0
  AlphaBlendValue = 100
  BorderStyle = bsSizeToolWin
  Caption = 'Trace'
  ClientHeight = 304
  ClientWidth = 675
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vstConsole: TVirtualStringTree
    Left = 0
    Top = 24
    Width = 675
    Height = 280
    Align = alClient
    Header.AutoSizeIndex = 2
    Header.MainColumn = 2
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines]
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
    OnGetText = vstConsoleGetText
    OnInitNode = vstConsoleInitNode
    Columns = <
      item
        Position = 0
        Width = 80
      end
      item
        Position = 3
        Width = 120
      end
      item
        Position = 4
        Width = 400
      end
      item
        Position = 1
      end
      item
        Position = 2
      end>
    DefaultText = ''
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 675
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Effacer'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
