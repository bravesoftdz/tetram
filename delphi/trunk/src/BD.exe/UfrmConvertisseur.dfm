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
    inline Frame11: TframBoutons
      Left = 2
      Top = 41
      Width = 185
      Height = 29
      Align = alBottom
      TabOrder = 0
      ExplicitLeft = 2
      ExplicitTop = 41
      ExplicitWidth = 185
      inherited btnOK: TButton
        Left = 22
        ExplicitLeft = 22
      end
      inherited btnAnnuler: TButton
        Left = 105
        ExplicitLeft = 105
      end
    end
  end
end
