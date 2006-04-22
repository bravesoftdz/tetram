object FrmConvers: TFrmConvers
  Left = 472
  Top = 177
  BorderStyle = bsNone
  Caption = 'FrmConvers'
  ClientHeight = 72
  ClientWidth = 189
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 189
    Height = 72
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 0
    inline Frame11: TFrame1
      Left = 2
      Top = 46
      Width = 185
      Height = 24
      Align = alBottom
      TabOrder = 0
      inherited btnOK: TBitBtn
        Left = 54
        Width = 54
        Height = 19
      end
      inherited btnAnnuler: TBitBtn
        Left = 112
        Width = 68
        Height = 19
      end
    end
  end
end
