object Fond: TFond
  Left = 553
  Top = 365
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  BorderWidth = 4
  ClientHeight = 166
  ClientWidth = 287
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMinimized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 138
    Height = 29
    Caption = 'WallPepper'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 144
    Top = 104
    Width = 132
    Height = 13
    Caption = 'Copyright Tetr'#228'm Corp 1995'
  end
  object Label3: TLabel
    Left = 240
    Top = 24
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Version'
  end
  object Label4: TLabel
    Left = 152
    Top = 72
    Width = 105
    Height = 13
    Cursor = crHandPoint
    Caption = 'http://www.tetram.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label4Click
  end
  object Label5: TLabel
    Left = 24
    Top = 56
    Width = 121
    Height = 29
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Informations, mises '#224' jour et autres produits:'
    Layout = tlBottom
    WordWrap = True
  end
  object Button1: TButton
    Left = 106
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 136
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 104
    object Changermaintenant1: TMenuItem
      Action = ChangerMaintenant
    end
    object Rafraichir1: TMenuItem
      Action = Rafraichir
    end
    object Slectionneruneimage1: TMenuItem
      Action = SelectionImage
    end
    object Choisiruneimageautre1: TMenuItem
      Action = ChoisirImage
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Vrifierlaversion1: TMenuItem
      Caption = 'V'#233'rifier la version'
      OnClick = Vrifierlaversion1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Supprimercetteimage1: TMenuItem
      Action = SupprimerImage
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Activ1: TMenuItem
      AutoCheck = True
      Caption = 'Activ'#233
      Checked = True
      OnClick = Activ1Click
    end
    object Options1: TMenuItem
      Action = Options
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Apropos1: TMenuItem
      Caption = 'A propos'
      OnClick = Apropos1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Quitter1: TMenuItem
      Action = FileExit1
    end
  end
  object TrayIcon1: TTrayIcon
    Icon.Data = {
      0000010001002020040000000000E80200001600000028000000200000004000
      0000010004000000000000020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0777777777777777777777000000000000000000000000000000000000000000
      00788880000133391788700000000000007888800003BB930C88700000000000
      0078888770388B777888700000000700000067888707887C8888700000007111
      1111100077178877888870000000191981777111100788778888700000001110
      0078877711107877888870000000711000788888871110078888700000000910
      0078888887077110788870000000001700788888871788911068700000000001
      70788888871788775100700000000000707888888717887C8711000000000000
      0078888887178877887910000000000000788888871788778888711700000000
      0078888887178877888871117000000000788888871788778888708917000000
      00788888871788778888700811700000007888888717887C8888700071100000
      0078887777078877888870000117000000788801193788310888700001110000
      0078887001399993178870007111000000788888740037707888707711110000
      0078888888877C88888870119190000000788888888888888888700000000000
      0000000000000000000000000000000007777777777777777777770000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FFFFFFFFFFFFF800003FF800003FF800003FF800003FF800003F8000003F0000
      003F0000003F1800003F1800003F9800003FC800003FE000003FF000003FF800
      003FF800000FF8000007F8000003F8000021F8000031F8000038F8000038F800
      0030F8000000F8000001F800003FF800003FF800003FFFFFFFFFFFFFFFFF}
    IconID = 1
    OnDblClick = TrayIcon1DblClick
    OnMouseMove = TrayIcon1MouseMove
    OnMouseUp = TrayIcon1MouseUp
    Active = False
    Left = 8
    Top = 104
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 40
    Top = 136
    object SupprimerImage: TAction
      Caption = 'Supprimer cette image'
      OnExecute = SupprimerImageExecute
    end
    object ChangerMaintenant: TAction
      Caption = 'Changer maintenant'
      OnExecute = ChangerMaintenantExecute
    end
    object Options: TAction
      Caption = 'Options'
      OnExecute = OptionsExecute
    end
    object FileExit1: TAction
      Caption = '&Quitter'
      Hint = 'Quitter|Quitter l'#39'application'
      ImageIndex = 43
      OnExecute = FileExit1Execute
    end
    object SelectionImage: TAction
      Caption = 'S'#233'lectionner une image'
      OnExecute = SelectionImageExecute
    end
    object ShowMenu: TAction
      Caption = 'ShowMenu'
      OnExecute = ShowMenuExecute
    end
    object ChoisirImage: TAction
      Caption = 'Choisir une image autre...'
      OnExecute = ChoisirImageExecute
    end
    object Rafraichir: TAction
      Caption = 'Rafraichir'
      OnExecute = RafraichirExecute
    end
    object ExecCommandePlugin: TAction
      Caption = 'ExecCommandePlugin'
      OnExecute = ExecCommandePluginExecute
    end
  end
  object Unrar1: TUnrar
    UsePath = True
    Left = 200
    Top = 104
  end
  object ZipMaster1: TZipMaster
    Verbose = False
    Trace = False
    AddCompLevel = 9
    AddOptions = []
    ExtrOptions = [ExtrForceDirs]
    Unattended = True
    VersionInfo = '1.73'
    AddStoreSuffixes = [assGIF, assPNG, assZ, assZIP, assZOO, assARC, assLZH, assARJ, assTAZ, assTGZ, assLHA, assRAR, assACE, assCAB, assGZ, assGZIP, assJAR]
    SpanOptions = []
    KeepFreeOnDisk1 = 0
    KeepFreeOnAllDisks = 0
    SFXCaption = 'Self-extracting Archive'
    SFXOverWriteMode = OvrConfirm
    SFXPath = 'DZSFXUS.BIN'
    Left = 200
    Top = 136
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 72
    Top = 136
  end
end
