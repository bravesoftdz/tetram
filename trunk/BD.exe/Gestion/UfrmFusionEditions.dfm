object frmFusionEditions: TfrmFusionEditions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Editions'
  ClientHeight = 336
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label44: TLabel
    Left = 8
    Top = 225
    Width = 268
    Height = 13
    Caption = 'Choisissez l'#39#233'dition dans laquelle fusionner ces donn'#233'es.'
  end
  object lbEditions: TListBox
    Left = 363
    Top = 225
    Width = 349
    Height = 56
    BevelInner = bvNone
    BevelKind = bkTile
    BevelOuter = bvNone
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbEditionsClick
  end
  object CheckBox1: TCheckBox
    Left = 363
    Top = 287
    Width = 145
    Height = 17
    Caption = 'Cr'#233'er une nouvelle '#233'dition'
    TabOrder = 1
    OnClick = CheckBox1Click
  end
  object pnEditionSrc: TPanel
    Left = 8
    Top = 8
    Width = 349
    Height = 211
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = ' '
    ParentColor = True
    TabOrder = 2
    object ISBN: TLabel
      Left = 56
      Top = 2
      Width = 23
      Height = 13
      Caption = 'ISBN'
    end
    object Editeur: TLabel
      Left = 56
      Top = 18
      Width = 34
      Height = 13
      Caption = 'Editeur'
      ShowAccelChar = False
    end
    object Prix: TLabel
      Left = 56
      Top = 52
      Width = 18
      Height = 13
      Caption = 'Prix'
    end
    object Lbl_numero: TLabel
      Left = 23
      Top = 2
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'ISBN :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Lbl_type: TLabel
      Left = 12
      Top = 18
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editeur :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 28
      Top = 52
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'Prix :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label9: TLabel
      Left = 0
      Top = 34
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Collection :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Collection: TLabel
      Left = 56
      Top = 34
      Width = 46
      Height = 13
      Caption = 'Collection'
      ShowAccelChar = False
    end
    object Label16: TLabel
      Left = 262
      Top = 18
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ann'#233'e :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object AnneeEdition: TLabel
      Left = 305
      Top = 18
      Width = 31
      Height = 13
      Caption = 'Ann'#233'e'
    end
    object Etat: TLabel
      Left = 56
      Top = 83
      Width = 20
      Height = 13
      Caption = 'Etat'
      ShowAccelChar = False
    end
    object Label10: TLabel
      Left = 26
      Top = 83
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = 'Etat :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Reliure: TLabel
      Left = 216
      Top = 83
      Width = 33
      Height = 13
      Caption = 'Reliure'
      ShowAccelChar = False
    end
    object Label13: TLabel
      Left = 168
      Top = 83
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = 'Reliure :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object TypeEdition: TLabel
      Left = 56
      Top = 128
      Width = 32
      Height = 13
      Caption = 'Edition'
      ShowAccelChar = False
    end
    object Label8: TLabel
      Left = 18
      Top = 146
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes :'
      Color = clWhite
      FocusControl = edNotes
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label12: TLabel
      Left = 156
      Top = 52
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'Achet'#233' le :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object AcheteLe: TLabel
      Left = 216
      Top = 52
      Width = 45
      Height = 13
      Caption = 'Achet'#233' le'
    end
    object Label15: TLabel
      Left = 17
      Top = 98
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Pages :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Pages: TLabel
      Left = 56
      Top = 98
      Width = 29
      Height = 13
      Caption = 'Pages'
    end
    object Label17: TLabel
      Left = 147
      Top = 98
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = 'Orientation :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lbOrientation: TLabel
      Left = 216
      Top = 98
      Width = 54
      Height = 13
      Caption = 'Orientation'
      ShowAccelChar = False
    end
    object Label19: TLabel
      Left = 167
      Top = 128
      Width = 41
      Height = 13
      Caption = 'Format :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lbFormat: TLabel
      Left = 216
      Top = 128
      Width = 34
      Height = 13
      Caption = 'Format'
      ShowAccelChar = False
    end
    object lbCote: TLabel
      Left = 56
      Top = 67
      Width = 23
      Height = 13
      Caption = 'Cote'
    end
    object Label20: TLabel
      Left = 23
      Top = 67
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Cote :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label21: TLabel
      Left = 127
      Top = 113
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Caption = 'Sens de lecture :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lbSensLecture: TLabel
      Left = 216
      Top = 113
      Width = 74
      Height = 13
      Caption = 'Sens de lecture'
      ShowAccelChar = False
    end
    object Label22: TLabel
      Left = 4
      Top = 190
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'N'#176' perso :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lbNumeroPerso: TLabel
      Left = 56
      Top = 190
      Width = 87
      Height = 13
      Caption = 'Numero personnel'
      ShowAccelChar = False
    end
    object cbVO: TReadOnlyCheckBox
      Left = 213
      Top = 17
      Width = 33
      Height = 16
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'VO'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 2
    end
    object cbCouleur: TReadOnlyCheckBox
      Left = 262
      Top = 33
      Width = 56
      Height = 15
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'Couleur'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 4
    end
    object cbStock: TReadOnlyCheckBox
      Left = 273
      Top = 1
      Width = 45
      Height = 15
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'Stock'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 1
    end
    object edNotes: TMemo
      Left = 56
      Top = 146
      Width = 287
      Height = 40
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object cbOffert: TReadOnlyCheckBox
      Left = 197
      Top = 1
      Width = 49
      Height = 16
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'Offert'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 0
    end
    object cbDedicace: TReadOnlyCheckBox
      Left = 183
      Top = 33
      Width = 63
      Height = 16
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'D'#233'dicac'#233
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 3
    end
  end
  object pnEditionDst: TPanel
    Left = 363
    Top = 8
    Width = 349
    Height = 211
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = ' '
    ParentColor = True
    TabOrder = 3
    object Label1: TLabel
      Left = 56
      Top = 2
      Width = 23
      Height = 13
      Caption = 'ISBN'
    end
    object Label2: TLabel
      Left = 56
      Top = 18
      Width = 34
      Height = 13
      Caption = 'Editeur'
      ShowAccelChar = False
    end
    object Label4: TLabel
      Left = 56
      Top = 52
      Width = 18
      Height = 13
      Caption = 'Prix'
    end
    object Label5: TLabel
      Left = 23
      Top = 2
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'ISBN :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label6: TLabel
      Left = 12
      Top = 18
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Editeur :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label7: TLabel
      Left = 28
      Top = 52
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = 'Prix :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label11: TLabel
      Left = 0
      Top = 34
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Collection :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label14: TLabel
      Left = 56
      Top = 34
      Width = 46
      Height = 13
      Caption = 'Collection'
      ShowAccelChar = False
    end
    object Label18: TLabel
      Left = 262
      Top = 18
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ann'#233'e :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label23: TLabel
      Left = 305
      Top = 18
      Width = 31
      Height = 13
      Caption = 'Ann'#233'e'
    end
    object Label24: TLabel
      Left = 56
      Top = 83
      Width = 20
      Height = 13
      Caption = 'Etat'
      ShowAccelChar = False
    end
    object Label25: TLabel
      Left = 26
      Top = 83
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Caption = 'Etat :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label26: TLabel
      Left = 216
      Top = 83
      Width = 33
      Height = 13
      Caption = 'Reliure'
      ShowAccelChar = False
    end
    object Label27: TLabel
      Left = 168
      Top = 83
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = 'Reliure :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label28: TLabel
      Left = 56
      Top = 128
      Width = 32
      Height = 13
      Caption = 'Edition'
      ShowAccelChar = False
    end
    object Label29: TLabel
      Left = 18
      Top = 146
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes :'
      Color = clWhite
      FocusControl = Memo1
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label30: TLabel
      Left = 156
      Top = 52
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'Achet'#233' le :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label31: TLabel
      Left = 216
      Top = 52
      Width = 45
      Height = 13
      Caption = 'Achet'#233' le'
    end
    object Label32: TLabel
      Left = 17
      Top = 98
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Pages :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label33: TLabel
      Left = 56
      Top = 98
      Width = 29
      Height = 13
      Caption = 'Pages'
    end
    object Label34: TLabel
      Left = 147
      Top = 98
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = 'Orientation :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label35: TLabel
      Left = 216
      Top = 98
      Width = 54
      Height = 13
      Caption = 'Orientation'
      ShowAccelChar = False
    end
    object Label36: TLabel
      Left = 167
      Top = 128
      Width = 41
      Height = 13
      Caption = 'Format :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label37: TLabel
      Left = 216
      Top = 128
      Width = 34
      Height = 13
      Caption = 'Format'
      ShowAccelChar = False
    end
    object Label38: TLabel
      Left = 56
      Top = 67
      Width = 23
      Height = 13
      Caption = 'Cote'
    end
    object Label39: TLabel
      Left = 23
      Top = 67
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Cote :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label40: TLabel
      Left = 127
      Top = 113
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Caption = 'Sens de lecture :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label41: TLabel
      Left = 216
      Top = 113
      Width = 74
      Height = 13
      Caption = 'Sens de lecture'
      ShowAccelChar = False
    end
    object Label42: TLabel
      Left = 4
      Top = 190
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'N'#176' perso :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label43: TLabel
      Left = 56
      Top = 190
      Width = 87
      Height = 13
      Caption = 'Numero personnel'
      ShowAccelChar = False
    end
    object ReadOnlyCheckBox1: TReadOnlyCheckBox
      Left = 213
      Top = 17
      Width = 33
      Height = 16
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'VO'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 2
    end
    object ReadOnlyCheckBox2: TReadOnlyCheckBox
      Left = 262
      Top = 33
      Width = 56
      Height = 15
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'Couleur'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 4
    end
    object ReadOnlyCheckBox3: TReadOnlyCheckBox
      Left = 273
      Top = 1
      Width = 45
      Height = 15
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'Stock'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 1
    end
    object Memo1: TMemo
      Left = 56
      Top = 146
      Width = 287
      Height = 40
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object ReadOnlyCheckBox4: TReadOnlyCheckBox
      Left = 197
      Top = 1
      Width = 49
      Height = 16
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'Offert'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 0
    end
    object ReadOnlyCheckBox5: TReadOnlyCheckBox
      Left = 183
      Top = 33
      Width = 63
      Height = 16
      TabStop = False
      Alignment = taLeftJustify
      Caption = 'D'#233'dicac'#233
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbGrayed
      TabOrder = 3
    end
  end
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 307
    Width = 720
    Height = 29
    Align = alBottom
    TabOrder = 4
    ExplicitTop = 307
    ExplicitWidth = 720
    inherited btnOK: TButton
      Left = 518
      Enabled = False
      ExplicitLeft = 518
    end
    inherited btnAnnuler: TButton
      Left = 603
      Width = 112
      Hint = ''
      Caption = 'Ne pas fusionner'
      ExplicitLeft = 603
      ExplicitWidth = 112
    end
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 264
    Width = 113
    Height = 17
    Caption = 'Importer les images'
    Checked = True
    State = cbChecked
    TabOrder = 5
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 287
    Width = 121
    Height = 17
    Caption = 'Remplacer les images'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
end
