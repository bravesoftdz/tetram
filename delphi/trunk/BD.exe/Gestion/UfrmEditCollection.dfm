object frmEditCollection: TfrmEditCollection
  Left = 546
  Top = 535
  ActiveControl = edNom
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Saisie de Collection'
  ClientHeight = 305
  ClientWidth = 806
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
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 29
    Width = 806
    Height = 4
    Align = alTop
    Shape = bsBottomLine
    ExplicitTop = 25
    ExplicitWidth = 410
  end
  object Label28: TLabel
    Left = 8
    Top = 4
    Width = 96
    Height = 23
    Caption = 'Collection'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 33
    Width = 806
    Height = 272
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      806
      272)
    object Label2: TLabel
      Left = 43
      Top = 10
      Width = 28
      Height = 13
      Hint = 'R'#233'f'#233'rence du support'
      Alignment = taRightJustify
      Caption = 'Nom :'
      FocusControl = edNom
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 30
      Top = 33
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editeur :'
    end
    object Label4: TLabel
      Left = 5
      Top = 71
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'Associations :'
      FocusControl = edAssociations
      Transparent = True
      Layout = tlCenter
    end
    object Bevel4: TBevel
      Left = 197
      Top = 59
      Width = 362
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object edNom: TEditLabeled
      Left = 77
      Top = 7
      Width = 726
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
      Left = 77
      Top = 30
      Width = 726
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 77
      ExplicitTop = 30
      ExplicitWidth = 726
      inherited btReset: TVDTButton
        Left = 663
        ExplicitLeft = 289
      end
      inherited btNew: TVDTButton
        Left = 705
        ExplicitLeft = 331
      end
      inherited btEdit: TVDTButton
        Left = 684
        ExplicitLeft = 310
      end
      inherited VTEdit: TJvComboEdit
        Width = 663
        ExplicitWidth = 660
      end
    end
    object edAssociations: TMemoLabeled
      Left = 77
      Top = 68
      Width = 726
      Height = 105
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssBoth
      TabOrder = 2
      WordWrap = False
      LinkControls = <
        item
          Control = Label4
        end>
    end
  end
  inline Frame11: TframBoutons
    Left = 0
    Top = 0
    Width = 806
    Height = 29
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 806
    inherited btnOK: TButton
      Left = 635
      Width = 87
      Caption = 'Enregistrer'
      OnClick = Frame11btnOKClick
      ExplicitLeft = 635
      ExplicitWidth = 87
    end
    inherited btnAnnuler: TButton
      Left = 723
      ExplicitLeft = 723
    end
  end
end
