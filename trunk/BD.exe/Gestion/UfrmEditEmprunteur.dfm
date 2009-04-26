object frmEditEmprunteur: TfrmEditEmprunteur
  Left = 550
  Top = 342
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  ActiveControl = edNom
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'frmEditEmprunteur'
  ClientHeight = 232
  ClientWidth = 521
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
    Top = 29
    Width = 521
    Height = 4
    Align = alTop
    Shape = bsBottomLine
    ExplicitTop = 25
    ExplicitWidth = 215
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 33
    Width = 521
    Height = 199
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      521
      199)
    object emprunts: TLabel
      Left = 60
      Top = 186
      Width = 3
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akBottom]
      Transparent = True
      ExplicitTop = 98
    end
    object Label2: TLabel
      Left = 6
      Top = 186
      Width = 52
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Emprunts :'
      Transparent = True
      ExplicitTop = 98
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
      Width = 512
      Height = 154
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object edNom: TEditLabeled
      Left = 37
      Top = 6
      Width = 479
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
  inline Frame11: TframBoutons
    Left = 0
    Top = 0
    Width = 521
    Height = 29
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 521
    inherited btnOK: TButton
      Left = 346
      Width = 87
      Caption = 'Enregistrer'
      OnClick = Frame11btnOKClick
      ExplicitLeft = 346
      ExplicitWidth = 87
    end
    inherited btnAnnuler: TButton
      Left = 438
      ExplicitLeft = 438
    end
  end
end
