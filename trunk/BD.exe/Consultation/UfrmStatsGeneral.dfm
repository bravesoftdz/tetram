object frmStatsGenerales: TfrmStatsGenerales
  Left = 519
  Top = 285
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Informations sur la BDth'#232'que'
  ClientHeight = 334
  ClientWidth = 504
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Bevel5: TBevel
    Left = 0
    Top = 0
    Width = 504
    Height = 81
    Align = alTop
    Shape = bsBottomLine
  end
  object Bevel6: TBevel
    Left = 0
    Top = 81
    Width = 504
    Height = 64
    Align = alTop
    Shape = bsBottomLine
  end
  object Bevel7: TBevel
    Left = 0
    Top = 145
    Width = 504
    Height = 68
    Align = alTop
    Shape = bsBottomLine
  end
  object Bevel8: TBevel
    Left = 0
    Top = 213
    Width = 504
    Height = 65
    Align = alTop
    Shape = bsBottomLine
  end
  object Label2: TLabel
    Left = 34
    Top = 7
    Width = 102
    Height = 15
    Alignment = taRightJustify
    Caption = 'Nombre d'#39'albums :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 49
    Top = 45
    Width = 87
    Height = 15
    Alignment = taRightJustify
    Caption = 'Albums en N&B :'
    ShowAccelChar = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 58
    Top = 60
    Width = 78
    Height = 15
    Alignment = taRightJustify
    Caption = 'Albums en VO :'
    ShowAccelChar = False
    Transparent = True
  end
  object Label5: TLabel
    Left = 271
    Top = 7
    Width = 98
    Height = 15
    Alignment = taRightJustify
    Caption = 'Albums en stock :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label8: TLabel
    Left = 75
    Top = 88
    Width = 61
    Height = 15
    Alignment = taRightJustify
    Caption = 'Prix moyen :'
    ShowAccelChar = False
    Transparent = True
  end
  object Spshtinter: TLabel
    Left = 319
    Top = 88
    Width = 22
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = '> >'
    ShowAccelChar = False
    Transparent = True
  end
  object Label12: TLabel
    Left = 49
    Top = 107
    Width = 87
    Height = 15
    Alignment = taRightJustify
    Caption = 'Valeur connue :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label13: TLabel
    Left = 46
    Top = 121
    Width = 90
    Height = 15
    Alignment = taRightJustify
    Caption = 'Valeur estim'#233'e :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label14: TLabel
    Left = 64
    Top = 149
    Width = 79
    Height = 15
    Alignment = taRightJustify
    Caption = 'Emprunteurs :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label15: TLabel
    Left = 290
    Top = 149
    Width = 138
    Height = 15
    Alignment = taRightJustify
    Caption = 'Nombre moyen d'#39'emprunts :'
    ShowAccelChar = False
    Transparent = True
  end
  object Label16: TLabel
    Left = 376
    Top = 164
    Width = 52
    Height = 15
    Alignment = taRightJustify
    Caption = 'maximum :'
    ShowAccelChar = False
    Transparent = True
  end
  object Label17: TLabel
    Left = 377
    Top = 185
    Width = 51
    Height = 15
    Alignment = taRightJustify
    Caption = 'minimum :'
    ShowAccelChar = False
    Transparent = True
  end
  object Label18: TLabel
    Left = 33
    Top = 215
    Width = 110
    Height = 15
    Alignment = taRightJustify
    Caption = 'Albums emprunt'#233's :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label19: TLabel
    Left = 290
    Top = 215
    Width = 138
    Height = 15
    Alignment = taRightJustify
    Caption = 'Nombre moyen d'#39'emprunts :'
    ShowAccelChar = False
    Transparent = True
  end
  object Label20: TLabel
    Left = 376
    Top = 230
    Width = 52
    Height = 15
    Alignment = taRightJustify
    Caption = 'maximum :'
    ShowAccelChar = False
    Transparent = True
  end
  object Label21: TLabel
    Left = 377
    Top = 251
    Width = 51
    Height = 15
    Alignment = taRightJustify
    Caption = 'minimum :'
    ShowAccelChar = False
    Transparent = True
  end
  object nb_Albums: TLabel
    Left = 141
    Top = 7
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object AlbumsNB: TLabel
    Left = 141
    Top = 45
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object AlbumsVO: TLabel
    Left = 141
    Top = 60
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object AlbumsStock: TLabel
    Left = 374
    Top = 7
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object PrixMoy: TLabel
    Left = 141
    Top = 88
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object min_emprunteurs: TLabel
    Left = 433
    Top = 185
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object max_emprunteurs: TLabel
    Left = 433
    Top = 164
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object moy_emprunteurs: TLabel
    Left = 433
    Top = 149
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object min_empruntee: TLabel
    Left = 433
    Top = 251
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object max_empruntee: TLabel
    Left = 433
    Top = 230
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object moy_empruntee: TLabel
    Left = 433
    Top = 215
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object TotalEstime: TLabel
    Left = 141
    Top = 121
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object TotalConnu: TLabel
    Left = 141
    Top = 107
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object nb_emprunteurs: TLabel
    Left = 148
    Top = 149
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object nb_empruntee: TLabel
    Left = 148
    Top = 215
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object PrixMax: TLabel
    Left = 344
    Top = 88
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object PrixMin: TLabel
    Left = 316
    Top = 88
    Width = 3
    Height = 15
    Alignment = taRightJustify
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Bevel1: TBevel
    Left = 29
    Top = 165
    Width = 347
    Height = 16
    Style = bsRaised
  end
  object Bevel2: TBevel
    Left = 29
    Top = 186
    Width = 347
    Height = 16
    Style = bsRaised
  end
  object Bevel3: TBevel
    Left = 29
    Top = 231
    Width = 347
    Height = 16
    Style = bsRaised
  end
  object Bevel4: TBevel
    Left = 29
    Top = 252
    Width = 347
    Height = 16
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 34
    Top = 23
    Width = 102
    Height = 15
    Alignment = taRightJustify
    Caption = 'Nombre de s'#233'ries :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object nb_Series: TLabel
    Left = 141
    Top = 23
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label9: TLabel
    Left = 316
    Top = 45
    Width = 52
    Height = 15
    Alignment = taRightJustify
    Caption = 'Int'#233'grales :'
    ShowAccelChar = False
    Transparent = True
  end
  object AlbumsIntegrales: TLabel
    Left = 373
    Top = 45
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 313
    Top = 60
    Width = 55
    Height = 15
    Alignment = taRightJustify
    Caption = 'Hors s'#233'rie :'
    ShowAccelChar = False
    Transparent = True
  end
  object AlbumsHorsSerie: TLabel
    Left = 373
    Top = 60
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object fermer: TButton
    Left = 216
    Top = 292
    Width = 72
    Height = 21
    Cursor = crHandPoint
    Caption = 'Fermer'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object listmaxemprunteurs: TListBox
    Left = 31
    Top = 165
    Width = 344
    Height = 15
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 15
    ParentFont = False
    TabOrder = 1
    OnExit = listeExit
  end
  object listminemprunteurs: TListBox
    Left = 31
    Top = 186
    Width = 344
    Height = 15
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 15
    ParentFont = False
    TabOrder = 2
    OnExit = listeExit
  end
  object listmaxempruntee: TListBox
    Left = 31
    Top = 231
    Width = 344
    Height = 15
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 15
    ParentFont = False
    TabOrder = 3
    OnExit = listeExit
  end
  object listminempruntee: TListBox
    Left = 31
    Top = 252
    Width = 344
    Height = 15
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 15
    ParentFont = False
    TabOrder = 4
    OnExit = listeExit
  end
end
