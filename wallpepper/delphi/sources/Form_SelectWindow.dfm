object FSelectWindow: TFSelectWindow
  Left = 442
  Top = 111
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'S'#233'lectionnez une fen'#234'tre'
  ClientHeight = 269
  ClientWidth = 395
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
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 393
    Height = 233
    Indent = 19
    TabOrder = 0
  end
  object Button5: TButton
    Left = 240
    Top = 244
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button3: TButton
    Left = 320
    Top = 244
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 2
  end
end
