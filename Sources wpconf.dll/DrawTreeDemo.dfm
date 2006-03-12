object DrawTreeForm: TDrawTreeForm
  Left = 367
  Top = 280
  Width = 571
  Height = 278
  BorderIcons = [biMinimize, biMaximize]
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    563
    246)
  PixelsPerInch = 96
  TextHeight = 13
  object Button5: TButton
    Left = 404
    Top = 220
    Width = 75
    Height = 25
    Action = actOk
    Anchors = [akRight, akBottom]
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button3: TButton
    Left = 482
    Top = 220
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 221
    Width = 75
    Height = 25
    Action = Essayer
    Anchors = [akLeft, akBottom]
    TabOrder = 2
  end
  object Panel2: TPanel
    Left = 320
    Top = 8
    Width = 237
    Height = 209
    BevelInner = bvLowered
    Caption = ' '
    TabOrder = 3
    object Label1: TLabel
      Left = 2
      Top = 181
      Width = 233
      Height = 13
      Align = alBottom
      Alignment = taCenter
      Caption = 'Label1'
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 2
      Top = 194
      Width = 233
      Height = 13
      Align = alBottom
      Alignment = taCenter
      Caption = 'Label2'
      Layout = tlCenter
    end
    object Image1: TImage
      Left = 2
      Top = 2
      Width = 233
      Height = 179
      Align = alClient
      Center = True
    end
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 305
    Height = 209
    ItemHeight = 13
    TabOrder = 4
    OnClick = ListBox1Click
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 104
    Top = 392
    object actOk: TAction
      Caption = 'Ok'
      OnExecute = actOkExecute
    end
    object Essayer: TAction
      Caption = 'Essayer'
      OnExecute = EssayerExecute
    end
  end
  object Unrar1: TUnrar
    UsePath = True
    Left = 168
    Top = 392
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
    Left = 136
    Top = 392
  end
end
