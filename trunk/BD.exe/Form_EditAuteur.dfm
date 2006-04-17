object FrmEditAuteur: TFrmEditAuteur
  Left = 537
  Top = 280
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  ActiveControl = edNom
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'FrmEditAuteur'
  ClientHeight = 219
  ClientWidth = 717
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
    Width = 717
    Height = 4
    Align = alTop
    Shape = bsBottomLine
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 27
    Width = 717
    Height = 192
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      717
      192)
    object Label3: TLabel
      Left = 28
      Top = 8
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Nom :'
      FocusControl = edNom
      Transparent = True
      Layout = tlCenter
    end
    object Label1: TLabel
      Left = 4
      Top = 55
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Caption = 'Biographie :'
      FocusControl = edNom
      Transparent = True
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 11
      Top = 32
      Width = 45
      Height = 13
      Hint = 'R'#233'f'#233'rence du support'
      Alignment = taRightJustify
      Caption = 'Site web:'
      Layout = tlCenter
    end
    object VDTButton13: TVDTButton
      Left = 687
      Top = 30
      Width = 23
      Height = 18
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Enabled = False
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555FFFFF555555555544C4C5555555555F777775FF5555554C444C444
        5555555775FF55775F55554C4334444445555575577F55557FF554C4C334C4C4
        335557F5577FF55577F554CCC3334444335557555777F555775FCCCCC333CCC4
        C4457F55F777F555557F4CC33333CCC444C57F577777F5F5557FC4333333C3C4
        CCC57F777777F7FF557F4CC33333333C4C457F577777777F557FCCC33CC4333C
        C4C575F7755F777FF5755CCCCC3333334C5557F5FF777777F7F554C333333333
        CC55575777777777F755553333CC3C33C555557777557577755555533CC4C4CC
        5555555775FFFF77555555555C4CCC5555555555577777555555}
      NumGlyphs = 2
      OnClick = VDTButton13Click
    end
    object edBiographie: TMemoLabeled
      Left = 64
      Top = 54
      Width = 648
      Height = 133
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssBoth
      TabOrder = 2
      LinkControls = <
        item
          Control = Label1
        end>
    end
    object edNom: TEditLabeled
      Left = 64
      Top = 4
      Width = 648
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
    object edSite: TEditLabeled
      Left = 64
      Top = 29
      Width = 622
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      OnChange = edSiteChange
      LinkControls = <
        item
          Control = Label2
        end>
      CurrencyChar = #0
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 717
    Height = 23
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    DesignSize = (
      717
      23)
    object btnOK: TBitBtn
      Left = 557
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
      Left = 639
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
