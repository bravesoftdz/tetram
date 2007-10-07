object FrmStatsEmprunteurs: TFrmStatsEmprunteurs
  Left = 532
  Top = 192
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Statistiques sur les emprunteurs'
  ClientHeight = 135
  ClientWidth = 448
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 448
    Height = 31
    Align = alTop
    Shape = bsBottomLine
  end
  object Label14: TLabel
    Left = 0
    Top = 35
    Width = 86
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Emprunteurs:'
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
    Left = 229
    Top = 35
    Width = 150
    Height = 16
    Hint = 'Nombre moyen d'#39'emprunts par emprunteurs'
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Nombre moyen d'#39'emprunts:'
    ShowAccelChar = False
    Transparent = True
  end
  object Label16: TLabel
    Left = 313
    Top = 51
    Width = 66
    Height = 16
    Hint = 'Maximum d'#39'emprunts'
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'maximum:'
    ShowAccelChar = False
    Transparent = True
  end
  object Label17: TLabel
    Left = 313
    Top = 73
    Width = 66
    Height = 15
    Hint = 'Nombre minimum d'#39'emprunts'
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'minimum:'
    ShowAccelChar = False
    Transparent = True
  end
  object min_emprunteurs: TLabel
    Left = 384
    Top = 73
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
  object max_emprunteurs: TLabel
    Left = 384
    Top = 51
    Width = 3
    Height = 15
    Hint = 'Maximum d'#39'emprunts'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object moy_emprunteurs: TLabel
    Left = 384
    Top = 35
    Width = 3
    Height = 15
    Hint = 'Nombre moyen d'#39'emprunts par emprunteurs'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object nb_emprunteurs: TLabel
    Left = 92
    Top = 35
    Width = 3
    Height = 15
    Hint = 'Nombre total d'#39'emprunteurs'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 9
    Top = 7
    Width = 99
    Height = 15
    Hint = 'Nombre total d'#39'albums dans la BDth'#232'que'
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
  object Label5: TLabel
    Left = 214
    Top = 7
    Width = 95
    Height = 15
    Hint = 'Nombre d'#39'albums disponobles'
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
    Left = 113
    Top = 7
    Width = 3
    Height = 15
    Hint = 'Nombre total d'#39'albums dans la BDth'#232'que'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object AlbumsStock: TLabel
    Left = 315
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
  end
  object Bevel5: TBevel
    Left = 5
    Top = 51
    Width = 321
    Height = 16
    Style = bsRaised
  end
  object Bevel1: TBevel
    Left = 5
    Top = 73
    Width = 321
    Height = 16
    Style = bsRaised
  end
  object Bevel3: TBevel
    Left = 0
    Top = 31
    Width = 448
    Height = 69
    Align = alTop
    Shape = bsBottomLine
  end
  object listmaxemprunteurs: TListBox
    Left = 7
    Top = 51
    Width = 318
    Height = 15
    Hint = 'Liste des emprunteurs ayant un maximum d'#39'emprunts'
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
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
  object listminemprunteurs: TListBox
    Left = 7
    Top = 73
    Width = 318
    Height = 15
    Hint = 'Liste des emprunteurs ayant un minimum d'#39'emprunts'
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
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
  object fermer: TButton
    Left = 185
    Top = 106
    Width = 77
    Height = 21
    Cursor = crHandPoint
    Hint = 'Fermer la fen'#234'tre'
    Caption = 'Fermer'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
end
