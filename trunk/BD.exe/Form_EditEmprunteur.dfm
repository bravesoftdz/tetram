object FrmEditEmprunteur: TFrmEditEmprunteur
  Left = 550
  Top = 342
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  ActiveControl = edNom
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'FrmEditEmprunteur'
  ClientHeight = 144
  ClientWidth = 215
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 23
    Width = 215
    Height = 4
    Align = alTop
    Shape = bsBottomLine
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 27
    Width = 215
    Height = 117
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      215
      117)
    object emprunts: TLabel
      Left = 60
      Top = 100
      Width = 3
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akBottom]
      Transparent = True
    end
    object Label2: TLabel
      Left = 6
      Top = 100
      Width = 49
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Emprunts:'
      Transparent = True
    end
    object Label3: TLabel
      Left = 4
      Top = 9
      Width = 28
      Height = 13
      Caption = 'Nom :'
      FocusControl = edNom
      Transparent = True
      Layout = tlCenter
    end
    object coord: TMemo
      Left = 4
      Top = 30
      Width = 206
      Height = 68
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object edNom: TEditLabeled
      Left = 37
      Top = 6
      Width = 173
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      LinkLabel.LinkLabel.Strings = (
        'Label3')
      LinkLabel.LinkControls = <>
      LinkControls = <
        item
          Control = Label3
        end>
      CurrencyChar = #0
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 215
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    DesignSize = (
      215
      23)
    object btnOK: TBitBtn
      Left = 55
      Top = 2
      Width = 73
      Height = 19
      Cursor = crHandPoint
      Anchors = [akRight, akBottom]
      Caption = 'Enregistrer'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = Frame11btnOKClick
    end
    object btnAnnuler: TBitBtn
      Left = 137
      Top = 2
      Width = 71
      Height = 19
      Cursor = crHandPoint
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Annuler'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnAnnulerClick
    end
  end
end
