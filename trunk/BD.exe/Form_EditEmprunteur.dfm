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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 25
    Width = 215
    Height = 4
    Align = alTop
    Shape = bsBottomLine
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 29
    Width = 215
    Height = 115
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      215
      115)
    object emprunts: TLabel
      Left = 60
      Top = 98
      Width = 3
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akBottom]
      Transparent = True
    end
    object Label2: TLabel
      Left = 6
      Top = 98
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
      Height = 66
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
      LinkControls = <
        item
          Control = Label3
        end>
      CurrencyChar = #0
    end
  end
  inline Frame11: TFrame1
    Left = 0
    Top = 0
    Width = 215
    Height = 25
    Align = alTop
    TabOrder = 1
    inherited btnOK: TBitBtn
      Left = 40
      Width = 87
      Caption = 'Enregistrer'
      OnClick = Frame11btnOKClick
    end
    inherited btnAnnuler: TBitBtn
      Left = 132
    end
  end
end
