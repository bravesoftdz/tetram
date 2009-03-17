object frmAboutBox: TfrmAboutBox
  Left = 408
  Top = 197
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'A propos'
  ClientHeight = 449
  ClientWidth = 535
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TBevel
    Left = 0
    Top = 0
    Width = 497
    Height = 449
    Style = bsRaised
  end
  object Panel1: TBevel
    Left = 6
    Top = 8
    Width = 483
    Height = 410
  end
  object Image1: TImage
    Left = 7
    Top = 71
    Width = 482
    Height = 346
    AutoSize = True
  end
  object ImLogo: TImage
    Left = 10
    Top = 10
    Width = 55
    Height = 40
    Cursor = crHandPoint
    AutoSize = True
    Picture.Data = {
      0A544A504547496D616765EF040000FFD8FFE000104A46494600010100000100
      010000FFDB0043000B08080A08070B0A090A0D0C0B0D111C12110F0F1122191A
      141C29242B2A282427272D3240372D303D302727384C393D43454849482B364F
      554E465440474845FFDB0043010C0D0D110F1121121221452E272E4545454545
      4545454545454545454545454545454545454545454545454545454545454545
      45454545454545454545454545FFC00011080028003703012200021101031101
      FFC4001F0000010501010101010100000000000000000102030405060708090A
      0BFFC400B5100002010303020403050504040000017D01020300041105122131
      410613516107227114328191A1082342B1C11552D1F02433627282090A161718
      191A25262728292A3435363738393A434445464748494A535455565758595A63
      6465666768696A737475767778797A838485868788898A92939495969798999A
      A2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6
      D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F01000301
      01010101010101010000000000000102030405060708090A0BFFC400B5110002
      0102040403040705040400010277000102031104052131061241510761711322
      328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728
      292A35363738393A434445464748494A535455565758595A636465666768696A
      737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7
      A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3
      E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F5A2
      401927005529F548D1B642A657F4519ACFD6AFD944CBBFCB8625E581EA71D2B8
      19FC5DAADDB1B5D36D8075380D0E7F3FCBAFF5ACDC8A513B5BDF11DC5B4FE4C9
      10858AEE01C8191EBFCAB32EBC5F736CF862871FDD607B66B8196DB59D52E5A1
      BA91CCB165544A79C8EC31DFB53EE3C31756AC4BCCAAABD64660AA39F53FD2B6
      8D19CBA994AB413B58F40B5F1FC6C409E353F43835D269BAE596A6079128127F
      718F35E113DADC5B301BF7231E195B209AB363A9CF6D2AED664743C1EF51352A
      6ED22E0E3515E27BFD15CF784BC4435DB122523ED3101BF1FC43D68A00C3F11E
      83AA5E6A12CB3C927F6697CB089C0217E95BBA16896365A622DBC63785C3B772
      6B62FBFE3CE524654292C319C815C969FE248D663F3288C92A146598F3DEA1A4
      99A26DA398B685EC3576866CB06BA31B15525E324E41FC7B73526B5A66AB6A9F
      6A6B859AD6E1C2004F249240CA10315D65D470DECBFDA160CAB33A85723F8D47
      3F811EB58DABDB45759924493CFC637BB0207F5AEB8621269B3927877AD8E4DE
      CE7135BC0D1BA0797055870ACBC9C54DAF6951448278B861D7DEB5A375B601EE
      279AEA519C1724E33D793585AE6A0F3290CC91AFF773935CF5EB7B59A68E8A14
      7D945A65FF008757CE3C5B0C084ED911C38FA293FCC0A2B6FE13E969E45EEA72
      41FBC771147211D80CB63F4FCA8A4B6096E7A45606B9E13B3D631221FB2DC8FF
      0096B1A8C37FBC3BD145311C15FE81E2CD365216D5AE909C992D9F76EFC383FA
      62A9AC5E309A4654D26F371C7FAC4DA38F73C51454B8A2B998F87C1DE30D5E5D
      B711A5A267979A41FA01935D7E87F0CB4BD3D84DA93B6A371C1FDE0C46A7FDDE
      FF008FE54514D2484DB67691C69122A46AA88A30154600A28A29927FFFD9}
    OnClick = ImLogoClick
  end
  object Label1: TLabel
    Left = 10
    Top = 47
    Width = 55
    Height = 13
    Cursor = crHandPoint
    AutoSize = False
    Caption = 'Tetr'#228'm Corp'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Layout = tlCenter
    OnClick = ImLogoClick
  end
  object VlTitre: TLabel
    Left = 303
    Top = 16
    Width = 186
    Height = 25
    AutoSize = False
    Caption = 'BDTh'#232'que'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object VlVersion: TfshVersionLabel
    Left = 303
    Top = 51
    Width = 186
    Height = 16
    AutoSize = False
    Caption = 'Version < Pas d'#39'information en mode design >'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    VersionResource = vrFileVersion
    VersionResourceKey = 'FileVersion'
    InfoPrefix = 'Version'
    ShowInfoPrefix = True
    LangCharset = '-1'
    DateTimeFormat = 'dd/MM/yyyy'
    FileSizeFormat = '#,#0" Bytes"'
  end
  object VlCopyright: TfshVersionLabel
    Left = 303
    Top = 69
    Width = 232
    Height = 13
    Caption = 'Copyright < Pas d'#39'information en mode design >'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    VersionResource = vrLegalCopyright
    VersionResourceKey = 'LegalCopyright'
    InfoPrefix = 'Copyright'
    ShowInfoPrefix = True
    LangCharset = '-1'
    DateTimeFormat = 'dd/MM/yyyy'
    FileSizeFormat = '#,#0" Bytes"'
  end
  object LbMemoireVirtuelleDisponible: TLabel
    Left = 310
    Top = 193
    Width = 121
    Height = 11
    Caption = 'LbMemoireVirtuelleDisponible'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LbMemoireVirtuelle: TLabel
    Left = 310
    Top = 182
    Width = 79
    Height = 11
    Caption = 'LbMemoireVirtuelle'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LbMemoireLibre: TLabel
    Left = 310
    Top = 171
    Width = 64
    Height = 11
    Caption = 'LbMemoireLibre'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LbMemoirePhysique: TLabel
    Left = 310
    Top = 159
    Width = 83
    Height = 11
    Caption = 'LbMemoirePhysique'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 303
    Top = 145
    Width = 42
    Height = 11
    Caption = 'M'#233'moire :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 303
    Top = 100
    Width = 43
    Height = 11
    Caption = 'Syst'#232'me :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LbSysteme: TLabel
    Left = 310
    Top = 115
    Width = 174
    Height = 28
    AutoSize = False
    Caption = 'LbSysteme'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object BtnOk: TButton
    Left = 226
    Top = 422
    Width = 75
    Height = 22
    Cursor = crHandPoint
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
