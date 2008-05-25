object FrmEditEditeur: TFrmEditEditeur
  Left = 513
  Top = 494
  ActiveControl = edNom
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Saisie d'#39'Editeur'
  ClientHeight = 388
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 25
    Width = 339
    Height = 4
    Align = alTop
    Shape = bsBottomLine
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 29
    Width = 339
    Height = 359
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    DesignSize = (
      339
      359)
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
    object Label1: TLabel
      Left = 1
      Top = 34
      Width = 45
      Height = 13
      Hint = 'R'#233'f'#233'rence du support'
      Alignment = taRightJustify
      Caption = 'Site web :'
      Layout = tlCenter
    end
    object VDTButton13: TVDTButton
      Left = 308
      Top = 32
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
    object edNom: TEditLabeled
      Left = 49
      Top = 7
      Width = 281
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
    object edSite: TEditLabeled
      Left = 49
      Top = 31
      Width = 256
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
          Control = Label1
        end>
      CurrencyChar = #0
    end
  end
  inline Frame11: TFrame1
    Left = 0
    Top = 0
    Width = 339
    Height = 25
    Align = alTop
    TabOrder = 1
    inherited btnOK: TBitBtn
      Left = 168
      Width = 87
      Caption = 'Enregistrer'
      OnClick = Frame11btnOKClick
    end
    inherited btnAnnuler: TBitBtn
      Left = 256
    end
  end
end
