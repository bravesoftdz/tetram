object FrmStatsAlbums: TFrmStatsAlbums
  Left = 658
  Top = 378
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Statistiques sur les albums'
  ClientHeight = 308
  ClientWidth = 396
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
  object Bevel3: TBevel
    Left = 0
    Top = 204
    Width = 396
    Height = 67
    Align = alBottom
    Shape = bsTopLine
  end
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 396
    Height = 113
    Align = alTop
    Shape = bsBottomLine
  end
  object Label7: TLabel
    Left = 254
    Top = 45
    Width = 47
    Height = 15
    Hint = 'Interval des ann'#233'es de sorties'
    Alignment = taCenter
    Caption = '> ann'#233'e >'
    ShowAccelChar = False
    Transparent = True
  end
  object Label11: TLabel
    Left = 41
    Top = 211
    Width = 107
    Height = 15
    Alignment = taRightJustify
    Caption = 'Albums emprunt'#233's:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label12: TLabel
    Left = 239
    Top = 211
    Width = 135
    Height = 15
    Hint = 'Nombre moyen d'#39'emprunts par albums'
    Alignment = taRightJustify
    Caption = 'Nombre moyen d'#39'emprunts:'
    ShowAccelChar = False
    Transparent = True
  end
  object Label13: TLabel
    Left = 325
    Top = 227
    Width = 49
    Height = 15
    Hint = 'Nombre maximum d'#39'emprunts'
    Alignment = taRightJustify
    Caption = 'maximum:'
    ShowAccelChar = False
    Transparent = True
  end
  object Label14: TLabel
    Left = 326
    Top = 249
    Width = 48
    Height = 15
    Hint = 'Nombre minimum d'#39'emprunts'
    Alignment = taRightJustify
    Caption = 'minimum:'
    ShowAccelChar = False
    Transparent = True
  end
  object nb_empruntee: TLabel
    Left = 154
    Top = 211
    Width = 3
    Height = 15
    Hint = 'Nombre d'#39'albums emprunt'#233's'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object max_empruntee: TLabel
    Left = 380
    Top = 227
    Width = 3
    Height = 15
    Hint = 'Nombre maximum d'#39'emprunts'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object moy_empruntee: TLabel
    Left = 380
    Top = 211
    Width = 3
    Height = 15
    Hint = 'Nombre moyen d'#39'emprunts par albums'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object min_empruntee: TLabel
    Left = 380
    Top = 249
    Width = 3
    Height = 15
    Hint = 'Nombre minimum d'#39'emprunts'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object minannee: TLabel
    Left = 248
    Top = 45
    Width = 3
    Height = 15
    Alignment = taRightJustify
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object maxannee: TLabel
    Left = 311
    Top = 45
    Width = 3
    Height = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Bevel5: TBevel
    Left = 5
    Top = 120
    Width = 385
    Height = 78
    Style = bsRaised
  end
  object Bevel2: TBevel
    Left = 0
    Top = 271
    Width = 396
    Height = 37
    Align = alBottom
    Shape = bsTopLine
  end
  object Bevel4: TBevel
    Left = 12
    Top = 226
    Width = 306
    Height = 17
    Style = bsRaised
  end
  object Bevel6: TBevel
    Left = 12
    Top = 248
    Width = 306
    Height = 17
    Style = bsRaised
  end
  object Label2: TLabel
    Left = 5
    Top = 7
    Width = 99
    Height = 15
    Alignment = taRightJustify
    Caption = 'Nombre d'#39'albums:'
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
    Left = 20
    Top = 45
    Width = 84
    Height = 15
    Hint = 'Nombre d'#39'albums en noir et blanc'
    Alignment = taRightJustify
    Caption = 'Albums en N&B:'
    ShowAccelChar = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 29
    Top = 59
    Width = 75
    Height = 15
    Hint = 'Nombre d'#39'albums en version originale'
    Alignment = taRightJustify
    Caption = 'Albums en VO:'
    ShowAccelChar = False
    Transparent = True
  end
  object Label5: TLabel
    Left = 210
    Top = 7
    Width = 95
    Height = 15
    Hint = 'Nombre d'#39'albums disponibles'
    Alignment = taRightJustify
    Caption = 'Albums en stock:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object nb_Albums: TLabel
    Left = 109
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
    Left = 109
    Top = 45
    Width = 3
    Height = 15
    Hint = 'Nombre d'#39'albums en noir et blanc'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object AlbumsVO: TLabel
    Left = 109
    Top = 59
    Width = 3
    Height = 15
    Hint = 'Nombre d'#39'albums en version originale'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object AlbumsStock: TLabel
    Left = 310
    Top = 7
    Width = 3
    Height = 15
    Hint = 'Nombre d'#39'albums disponibles'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 5
    Top = 23
    Width = 99
    Height = 15
    Alignment = taRightJustify
    Caption = 'Nombre de s'#233'ries:'
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
    Left = 109
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
    Left = 55
    Top = 73
    Width = 49
    Height = 15
    Hint = 'Nombre d'#39'int'#233'grales'
    Alignment = taRightJustify
    Caption = 'Int'#233'grales:'
    ShowAccelChar = False
    Transparent = True
  end
  object AlbumsIntegrales: TLabel
    Left = 109
    Top = 73
    Width = 3
    Height = 15
    Hint = 'Nombre d'#39'int'#233'grales'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 52
    Top = 89
    Width = 52
    Height = 15
    Hint = 'Nombre de hors s'#233'rie'
    Alignment = taRightJustify
    Caption = 'Hors s'#233'rie:'
    ShowAccelChar = False
    Transparent = True
  end
  object AlbumsHorsSerie: TLabel
    Left = 109
    Top = 89
    Width = 3
    Height = 15
    Hint = 'Nombre de hors s'#233'rie'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object genre: TListBox
    Left = 7
    Top = 122
    Width = 382
    Height = 75
    Hint = 'R'#233'partitions des albums par genre'
    BorderStyle = bsNone
    Columns = 2
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 15
    ParentFont = False
    TabOrder = 0
    OnExit = listeExit
  end
  object listmaxempruntee: TListBox
    Left = 13
    Top = 227
    Width = 304
    Height = 15
    Hint = 'Liste des albums les plus emprunt'#233's'
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
  object listminempruntee: TListBox
    Left = 13
    Top = 249
    Width = 304
    Height = 15
    Hint = 'Liste des albums les moins emprunt'#233's'
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
  object fermer: TButton
    Left = 160
    Top = 277
    Width = 77
    Height = 22
    Cursor = crHandPoint
    Hint = 'Fermer la fen'#234'tre'
    Caption = 'Fermer'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
end
