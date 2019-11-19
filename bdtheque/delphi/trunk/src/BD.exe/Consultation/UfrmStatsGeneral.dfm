object frmStatsGenerales: TfrmStatsGenerales
  Left = 519
  Top = 285
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Informations sur la BDth'#232'que'
  ClientHeight = 243
  ClientWidth = 504
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
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
    Height = 127
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
    Font.Color = clBlack
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
    Font.Color = clBlack
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
    Left = 50
    Top = 135
    Width = 86
    Height = 15
    Alignment = taRightJustify
    Caption = 'Valeur connue :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label13: TLabel
    Left = 47
    Top = 149
    Width = 89
    Height = 15
    Alignment = taRightJustify
    Caption = 'Valeur estim'#233'e :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
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
  object TotalEstimeMoyenne: TLabel
    Left = 141
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
  object TotalConnu: TLabel
    Left = 141
    Top = 135
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
  object Label1: TLabel
    Left = 34
    Top = 23
    Width = 102
    Height = 15
    Alignment = taRightJustify
    Caption = 'Nombre de s'#233'ries :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
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
  object Label7: TLabel
    Left = 73
    Top = 102
    Width = 62
    Height = 15
    Alignment = taRightJustify
    Caption = 'Prix m'#233'dian :'
    ShowAccelChar = False
    Transparent = True
  end
  object PrixMedian: TLabel
    Left = 141
    Top = 102
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
  object Label10: TLabel
    Left = 217
    Top = 149
    Width = 55
    Height = 15
    Caption = '(Moyenne)'
    ShowAccelChar = False
    Transparent = True
  end
  object TotalEstimeMediane: TLabel
    Left = 141
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
  object Label14: TLabel
    Left = 222
    Top = 164
    Width = 50
    Height = 15
    Caption = '(M'#233'diane)'
    ShowAccelChar = False
    Transparent = True
  end
  object TotalEstimeRF: TLabel
    Left = 141
    Top = 179
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
  object Label16: TLabel
    Left = 116
    Top = 179
    Width = 156
    Height = 15
    Caption = '(R'#233'gression par Random Forest)'
    ShowAccelChar = False
    Transparent = True
  end
  object fermer: TButton
    Left = 216
    Top = 214
    Width = 72
    Height = 21
    Cursor = crHandPoint
    Caption = 'Fermer'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
