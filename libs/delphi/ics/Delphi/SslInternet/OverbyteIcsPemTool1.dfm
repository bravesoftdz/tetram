object frmPemTool1: TfrmPemTool1
  Left = 212
  Top = 124
  Width = 541
  Height = 448
  Color = clBtnFace
  Constraints.MinHeight = 379
  Constraints.MinWidth = 527
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    533
    394)
  PixelsPerInch = 96
  TextHeight = 14
  object btnShowCert: TButton
    Left = 454
    Top = 24
    Width = 75
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&View PEM'
    TabOrder = 1
    OnClick = btnShowCertClick
  end
  object PageControl1: TPageControl
    Left = 2
    Top = 2
    Width = 450
    Height = 364
    ActivePage = TabCertLv
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    OnChange = PageControl1Change
    object TabCertLv: TTabSheet
      Caption = 'Certificates'
      DesignSize = (
        442
        335)
      object Label4: TLabel
        Left = 4
        Top = 314
        Width = 47
        Height = 14
        Anchors = [akLeft, akBottom]
        Caption = 'Directory:'
      end
      object LvCerts: TListView
        Left = 4
        Top = 6
        Width = 434
        Height = 298
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            AutoSize = True
            Caption = 'Issued to'
          end
          item
            AutoSize = True
            Caption = 'Issuer'
          end
          item
            Caption = 'Expires at'
            Width = 65
          end
          item
            Caption = 'File Name'
            Width = 70
          end>
        ReadOnly = True
        RowSelect = True
        PopupMenu = pmLv
        SmallImages = ImageList1
        SortType = stData
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = LvCertsColumnClick
        OnCompare = LvCertsCompare
        OnCustomDraw = LvCertsCustomDraw
        OnDblClick = LvCertsDblClick
      end
      object btnRefresh: TButton
        Left = 367
        Top = 311
        Width = 71
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = '&Refresh'
        TabOrder = 4
        OnClick = btnRefreshClick
      end
      object CurrentCertDirEdit: TEdit
        Left = 54
        Top = 310
        Width = 144
        Height = 22
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 1
        Text = 'CurrentCertDirEdit'
        OnChange = CurrentCertDirEditChange
      end
      object btnDeleteCert: TButton
        Left = 287
        Top = 311
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = '&Delete'
        TabOrder = 3
        OnClick = btnDeleteCertClick
      end
      object btnCopyCert: TButton
        Left = 207
        Top = 311
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = '&Copy'
        TabOrder = 2
        OnClick = btnCopyCertClick
      end
    end
    object TabImport: TTabSheet
      Caption = 'Import Certificates'
      ImageIndex = 1
      DesignSize = (
        442
        335)
      object Bevel2: TBevel
        Left = 4
        Top = 264
        Width = 434
        Height = 64
        Anchors = [akLeft, akTop, akRight]
        Shape = bsFrame
      end
      object Bevel1: TBevel
        Left = 4
        Top = 6
        Width = 434
        Height = 247
        Anchors = [akLeft, akTop, akRight]
        Shape = bsFrame
      end
      object Label1: TLabel
        Left = 20
        Top = 28
        Width = 327
        Height = 56
        Caption = 
          'Current user'#39's Windows-System-Certificate-Store is opened.'#13#10'Then' +
          ' the DER formated certs are read and translated to PEM format.'#13#10 +
          'Certs are stored to the specified folder in the form of Hash.0.'#13 +
          #10'The '#39'Cert. Store Type'#39' box has static values: CA, ROOT, MY.'
      end
      object Label3: TLabel
        Left = 22
        Top = 94
        Width = 82
        Height = 14
        Caption = 'Cert. Store Type:'
      end
      object Label2: TLabel
        Left = 22
        Top = 118
        Width = 75
        Height = 14
        Caption = 'Destination Dir.:'
      end
      object Label5: TLabel
        Left = 20
        Top = 12
        Width = 338
        Height = 14
        Caption = 'Import a Windows Ceritificate Store to a Folder in PEM Format'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 16
        Top = 270
        Width = 26
        Height = 14
        Caption = 'Misc'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ComboBoxStoreType: TComboBox
        Left = 106
        Top = 90
        Width = 227
        Height = 22
        Hint = 'Select a Windows store type'
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        Items.Strings = (
          'Certificate Authorities'
          'Root Certificate Authorities'
          'My Own Certificates')
      end
      object DestDirEdit: TEdit
        Left = 106
        Top = 114
        Width = 227
        Height = 22
        Hint = 'Existing destination directory '
        TabOrder = 1
        Text = 'DestDirEdit'
        OnChange = DestDirEditChange
      end
      object CheckBoxWarnDestNotEmpty: TCheckBox
        Left = 106
        Top = 146
        Width = 243
        Height = 17
        Caption = 'Warn me if destination folder is not empty'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object CheckBoxOverwriteExisting: TCheckBox
        Left = 106
        Top = 164
        Width = 243
        Height = 17
        Hint = 
          'If enabled, existing certs with the same name are overwritten.'#13#10 +
          'If not enabled, file extensions are changed. '#13#10'(e.g. 9d66eef0.0,' +
          ' 9d66eef0.1 etc)'
        Caption = 'Overwrite existing files, don'#39't change file ext.'
        TabOrder = 3
      end
      object CheckBoxEmptyDestDir: TCheckBox
        Left = 106
        Top = 182
        Width = 243
        Height = 17
        Hint = 'Warning! - deletes any file in destination folder '
        Caption = 'Empty destination directory'
        TabOrder = 4
      end
      object btnImport: TButton
        Left = 104
        Top = 222
        Width = 229
        Height = 21
        Caption = 'Start import from Windows'
        TabOrder = 6
        OnClick = btnImportClick
      end
      object btnImportPemFile: TButton
        Left = 102
        Top = 284
        Width = 231
        Height = 21
        Caption = 'Import/Hash a PEM Cert File to Destination Dir.'
        TabOrder = 7
        OnClick = btnImportPemFileClick
      end
      object CheckBoxWriteToBundle: TCheckBox
        Left = 106
        Top = 200
        Width = 145
        Height = 17
        Caption = 'Create a CA bundle file'
        TabOrder = 5
      end
    end
  end
  object About: TButton
    Left = 454
    Top = 345
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&About'
    TabOrder = 2
    OnClick = AboutClick
  end
  object ProgressBar1: TProgressBar
    Left = 454
    Top = 4
    Width = 73
    Height = 16
    Anchors = [akTop, akRight]
    TabOrder = 3
    Visible = False
  end
  object pmLv: TPopupMenu
    Left = 74
    Top = 188
    object pmShowDetails: TMenuItem
      Caption = 'Show Details'
      OnClick = LvCertsDblClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object pmCopy: TMenuItem
      Caption = 'Copy Certificate'
      OnClick = btnCopyCertClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pmDelete: TMenuItem
      Caption = 'Delete Certificate'
      OnClick = btnDeleteCertClick
    end
  end
  object ImageList1: TImageList
    Left = 40
    Top = 186
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000086000000860000008600000086
      0000008600000086000000860000008600000086000000860000008600000086
      0000008600000086000000860000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000086000084868400C6C7C600C6C7
      C600C6C7C60084868400C6C7C600C6C7C600C6C7C600C6C7C60084868400C6C7
      C600C6C7C6008486840000860000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000860000C6C7C600000000000000
      000000FFFF00000000000000000000000000000000000000000000FFFF000000
      000000000000C6C7C60000860000000000000000000000000000000000000000
      000000000000000000000000000084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000860000C6C7C600000000000000
      0000840000008400000084000000840000008400000084000000840000008400
      000084000000C6C7C60000860000000000000000000000000000000000000000
      00000000000000000000848684000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084868400000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000008600008486840000FFFF000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000008486840000860000000000000000000000000000000000000000
      00000000000000000000848684000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008486840000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000860000C6C7C600000000000000
      000000FFFF0000000000000000008400000000000000000000008400000000FF
      FF0000000000C6C7C60000860000000000000000000000000000000000000000
      0000000000008486840000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008486840000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000860000C6C7C60000000000C6C7
      C60000868400C6C7C6008400000000FFFF00C6C7C60084000000000000008400
      000000000000C6C7C60000860000000000000000000000000000000000000000
      0000000000008486840000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000848684000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000086000084868400000000000086
      8400848684000086840000000000840000000000000000000000C6C7C6000000
      0000000000008486840000860000000000000000000000000000000000000000
      000084868400000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000848684000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000860000C6C7C60000000000C6C7
      C60000868400C6C7C600000000000000000000000000000000000000000000FF
      FF0000000000C6C7C60000860000000000000000000000000000000000000000
      000084868400848684008486840084868400848684008486840084868400FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000860000C6C7C60000FFFF000000
      0000000000000000000000FFFF00000000000000000000FFFF00000000000000
      000000000000C6C7C60000860000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000086000084868400C6C7C600C6C7
      C600C6C7C600C6C7C60084868400C6C7C600C6C7C600C6C7C60084868400C6C7
      C600C6C7C6008486840000860000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000086000000860000008600000086
      0000008600000086000000860000008600000086000000860000008600000086
      0000008600000086000000860000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF00008000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF0000
      37D8FE7FF00F00003000FDBFF7EF00001F78FDBFFBDF000036C8FBDFFBDF0000
      2028FBDFFDBF000022D8F7EFFDBF000023E8F00FFE7F00001DB8FFFFFFFF0000
      0000FFFFFFFF00000001FFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object OpenDlg: TOpenDialog
    Filter = 'All Files *.*|*.*|PEM Files *.pem|*.pem'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 48
    Top = 232
  end
  object MainMenu1: TMainMenu
    Left = 254
    Top = 2
    object MMFile: TMenuItem
      Caption = '&File'
      object MMFileExit: TMenuItem
        Caption = '&Exist'
        OnClick = MMFileExitClick
      end
    end
    object MMExtras: TMenuItem
      Caption = '&Extras'
      object MMExtrasCreateSelfSignedCert: TMenuItem
        Caption = 'Create a self-signed certificate..'
        OnClick = MMExtrasCreateSelfSignedCertClick
      end
      object MMExtrasCreateCertRequest: TMenuItem
        Caption = 'Create a certificate request..'
        OnClick = MMExtrasCreateCertRequestClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object MMExtrasEncryptStringRSA: TMenuItem
        Caption = 'RSA encrypt/decrypt..'
        OnClick = MMExtrasEncryptStringRSAClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object MMExtrasEncryptStringBlowfish: TMenuItem
        Caption = 'Blowfish encrypt/decrypt string'
        OnClick = MMExtrasEncryptStringBlowfishClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object MMExtrasEncryptStreamBlowfish: TMenuItem
        Caption = 'Blowfish encrypt/decrypt stream'
        OnClick = MMExtrasEncryptStreamBlowfishClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object MMExtrasEncryptFileBlowfish: TMenuItem
        Caption = 'Blowfish encrypt file..'
        OnClick = MMExtrasEncryptFileBlowfishClick
      end
      object MMExtrasDecryptFileBlowfish: TMenuItem
        Caption = 'Blowfish decrypt file..'
        OnClick = MMExtrasDecryptFileBlowfishClick
      end
    end
  end
end
