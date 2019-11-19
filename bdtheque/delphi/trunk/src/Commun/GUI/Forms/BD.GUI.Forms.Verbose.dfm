object frmVerbose: TfrmVerbose
  Left = 410
  Top = 423
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Op'#233'ration en cours...'
  ClientHeight = 167
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  DesignSize = (
    459
    167)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 459
    Height = 131
    Align = alTop
    BevelKind = bkTile
    BorderStyle = bsNone
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 379
    Top = 136
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Anchors = [akTop, akRight]
    Caption = 'Fermer'
    Enabled = False
    TabOrder = 1
    OnClick = Button1Click
  end
end
