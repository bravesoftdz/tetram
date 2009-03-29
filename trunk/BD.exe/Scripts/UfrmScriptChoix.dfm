object frmScriptChoix: TfrmScriptChoix
  Left = 0
  Top = 0
  Caption = 'frmScriptChoix'
  ClientHeight = 383
  ClientWidth = 499
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
    Width = 499
    Height = 25
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = -25
    ExplicitTop = 136
    inherited btnOK: TButton
      Left = 336
    end
    inherited btnAnnuler: TButton
      Left = 416
    end
  end
  object VirtualStringTree1: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 499
    Height = 358
    Align = alClient
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
    OnGetText = VirtualStringTree1GetText
    OnPaintText = VirtualStringTree1PaintText
    OnInitChildren = VirtualStringTree1InitChildren
    OnInitNode = VirtualStringTree1InitNode
    OnMeasureItem = VirtualStringTree1MeasureItem
    ExplicitLeft = 64
    ExplicitTop = 48
    ExplicitWidth = 200
    ExplicitHeight = 100
    Columns = <
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coSmartResize, coAllowFocus]
        Position = 0
        Width = 250
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coSmartResize, coAllowFocus]
        Position = 1
        Width = 230
      end>
  end
end
