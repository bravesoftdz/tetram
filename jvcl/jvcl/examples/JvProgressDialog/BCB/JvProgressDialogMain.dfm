object frmProgressDialogDemo: TfrmProgressDialogDemo
  Left = 107
  Top = 120
  Width = 439
  Height = 239
  Caption = 'JvProgressDialog Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 330
    Top = 6
    Width = 24
    Height = 24
    AutoSize = True
    Picture.Data = {
      07544269746D617076060000424D760600000000000036040000280000001800
      000018000000010008000000000040020000120B0000120B0000000100008600
      000000FFFF00E7E7E700E7E7DE00EFDEDE00E7DED600E7D6C600E7CEC600E7CE
      BD00EFCEBD00FFFF0000E7C6B500E7BDAD00DEBDAD00DEB5AD00DEADA500D6AD
      A500D6AD9C00DEAD9400CEA5A500CEA59C00D6A59400C69C9400D69C8C00BD94
      9400CE948C00BD948C00B5948C00C68C8400B58C8400D68C7B00BD8C7B00BD84
      7B00AD847B00C6847300A5847B00A57B7B00B57B7300947B7300B5736B008C73
      73009C736B00A56B6B00946B6B008C6B6B00A56B6300946B6300846363008C63
      6300A5635A007B63630084635A009C5A5A008C5A5A00845A5A00635A63007B5A
      5A00845A5200735A52007B5252007352520084524A006B5252004A525A00634A
      52007B4A4A00734A4A006B4A4A005A4A52005A4A4A00634A4A00734A4200394A
      52006B4A4200634A4200634242006B42420039424A005A424200524242004A42
      42005A423900523942004A3942005A393900523939004A393900523931003931
      39004231390052313100293139004A3131004229310039293100312931004A29
      2900212931002929310039292900422929003129290039212900312129002921
      2900392121002121290031212100211829003118210029182100211821001818
      2100101821002918180018181800211818001810210029101800211018001810
      1800FF0000000810180010101800181010001010100010081800100810000808
      1000100808000808080000080800080010000800080000000800000000000000
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
      00006F795A475A7A7A797E7C7F7C7F7C7F7E0978787878787878797F70697079
      6F77747C7C7C7E7C7E7C09787800007878787F7C7F697A6F3E60677A7A7A7A7C
      7C72097800787800787882697F6F57694C67576E6F777277726E097800787800
      7878847F727F6743676D5E52676E6E735E6D097878787800787884817C7E774F
      316362315C5D64664D710978787878007878847F7C7C7B6D3722502B394A554A
      42620978787878007878847C7C74736D55221A38172A3A28493F097878787878
      78787E6F69765E52554013130F1E261E293209090909090909097E6F6E726D5B
      3723240A06070D10181C1222546A6D727C7E7E76736C62544833160704030404
      06112C405362445E727E4E3D2E2A221C15100C0504010104050B0E151A232A37
      3F557C766D6A635441331B07040201040C21303C4B59636868717E7A67736659
      2E1213140A070504101624465F667572777E7E7E776B4E27253B341F161D100D
      08263A394D6C77777C7E7F7D5E364E66624E3D381F302C10240D3A5B6566737E
      7C7E7C6961617476675C5C3241484020352D19596C737B7C7E7C837F7C7A7A7B
      6E6D653D5C555B4537562F2F6A7467807C7F84837F7C7C7E77675D5D6D666665
      3F64683B5177777E817F8484847F7C7E7C6E5D6E736E736E5867766D4E677A7E
      81818584847E7C817C7774777C72777773677A7B76577C7E8184858584847E7F
      7C7A7C7F7C7A7C77776F7C7C7E776E7F848585858484847F7F677C7C7C696F7E
      7C7D7C7E7C7E7F7F84848585858484847F7F817F7F7C7F7E7C7A6F7C7F7F7F72
      7F84}
  end
  object Label1: TLabel
    Left = 12
    Top = 60
    Width = 72
    Height = 13
    Hint = 
      'Caption of dialog: set to empty string to remove Caption altoget' +
      'her'
    Caption = '&Dialog Caption:'
    FocusControl = edCaption
  end
  object Label2: TLabel
    Left = 12
    Top = 108
    Width = 68
    Height = 13
    Hint = 'Text above progressbar'
    Caption = 'Progress &Text:'
    FocusControl = edText
  end
  object btnExecute: TButton
    Left = 231
    Top = 164
    Width = 90
    Height = 25
    Caption = 'Show &Progress'
    Default = True
    TabOrder = 0
    OnClick = btnExecuteClick
  end
  object chkShowLogo: TCheckBox
    Left = 12
    Top = 12
    Width = 97
    Height = 17
    Hint = 'Show Image in dialog: same as the one to the right'
    Caption = 'Show &Image'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object chkShowCancel: TCheckBox
    Left = 12
    Top = 36
    Width = 151
    Height = 17
    Hint = 'Show a Cancel button on the form'
    Caption = 'Show &Cancel button'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object edCaption: TEdit
    Left = 12
    Top = 78
    Width = 313
    Height = 21
    TabOrder = 3
    Text = 'Displaying demo progress...'
  end
  object edText: TEdit
    Left = 12
    Top = 126
    Width = 313
    Height = 21
    TabOrder = 4
    Text = 'Showing off, please wait... (%d%% finished)'
  end
  object chkShowEvents: TCheckBox
    Left = 24
    Top = 156
    Width = 97
    Height = 17
    Hint = 'Show dialogs when events occur (in this demo only)'
    Caption = 'Show &Events'
    TabOrder = 5
  end
  object btnSelectImage: TButton
    Left = 240
    Top = 6
    Width = 75
    Height = 25
    Caption = 'I&mage...'
    TabOrder = 6
    OnClick = btnSelectImageClick
  end
  object chkTransparent: TCheckBox
    Left = 246
    Top = 42
    Width = 81
    Height = 17
    Caption = 'T&ransparent'
    TabOrder = 7
  end
  object chkShowModal: TCheckBox
    Left = 24
    Top = 180
    Width = 97
    Height = 17
    Caption = 'Show Modal'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 204
    Top = 6
  end
end
