object FrmEditCollection: TFrmEditCollection
  Left = 546
  Top = 535
  ActiveControl = edNom
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Saisie de Collection'
  ClientHeight = 186
  ClientWidth = 410
  Color = clBtnFace
  Constraints.MinWidth = 416
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 25
    Width = 410
    Height = 4
    Align = alTop
    Shape = bsBottomLine
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 29
    Width = 410
    Height = 157
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      410
      157)
    object Label2: TLabel
      Left = 18
      Top = 10
      Width = 28
      Height = 13
      Hint = 'R'#233'f'#233'rence du support'
      Alignment = taRightJustify
      Caption = 'Nom :'
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 5
      Top = 33
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editeur :'
    end
    object edNom: TEditLabeled
      Left = 52
      Top = 7
      Width = 353
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      LinkControls = <
        item
          Control = Label2
        end>
      CurrencyChar = #0
    end
    inline vtEditEditeurs: TframVTEdit
      Left = 52
      Top = 30
      Width = 352
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 52
      ExplicitTop = 30
      ExplicitWidth = 352
      inherited btReset: TVDTButton
        Left = 289
        ExplicitLeft = 289
      end
      inherited btNew: TVDTButton
        Left = 331
        ExplicitLeft = 331
      end
      inherited btEdit: TVDTButton
        Left = 310
        ExplicitLeft = 310
      end
      inherited VTEdit: TJvComboEdit
        Width = 289
        ExplicitWidth = 289
      end
    end
  end
  inline Frame11: TframBoutons
    Left = 0
    Top = 0
    Width = 410
    Height = 25
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 410
    inherited btnOK: TButton
      Left = 239
      Width = 87
      Caption = 'Enregistrer'
      OnClick = Frame11btnOKClick
      ExplicitLeft = 239
      ExplicitWidth = 87
    end
    inherited btnAnnuler: TButton
      Left = 327
      ExplicitLeft = 327
    end
  end
end
