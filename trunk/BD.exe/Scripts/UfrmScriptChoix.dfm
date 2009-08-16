object frmScriptChoix: TfrmScriptChoix
  Left = 0
  Top = 0
  Caption = 'frmScriptChoix'
  ClientHeight = 383
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 358
    Width = 567
    Height = 25
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 358
    ExplicitWidth = 567
    ExplicitHeight = 25
    inherited btnOK: TButton
      Left = 404
      ExplicitLeft = 404
    end
    inherited btnAnnuler: TButton
      Left = 484
      ExplicitLeft = 484
    end
  end
  object VirtualStringTree1: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 567
    Height = 358
    Align = alClient
    BevelKind = bkTile
    BorderStyle = bsNone
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag]
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnAfterCellPaint = VirtualStringTree1AfterCellPaint
    OnDblClick = VirtualStringTree1DblClick
    OnGetText = VirtualStringTree1GetText
    OnPaintText = VirtualStringTree1PaintText
    OnInitChildren = VirtualStringTree1InitChildren
    OnInitNode = VirtualStringTree1InitNode
    OnMeasureItem = VirtualStringTree1MeasureItem
    Columns = <
      item
        Position = 0
        Width = 250
      end
      item
        Position = 1
        Width = 230
      end
      item
        Position = 2
        Width = 80
      end>
  end
end
