object frmSaisieEmpruntEmprunteur: TfrmSaisieEmpruntEmprunteur
  Left = 547
  Top = 219
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Saisie d'#39'un mouvement'
  ClientHeight = 389
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 526
    Height = 358
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel4'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 0
      Top = 172
      Width = 526
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitWidth = 525
    end
    object Panel2: TPanel
      Left = 0
      Top = 175
      Width = 526
      Height = 183
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 2
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 526
        Height = 155
        Align = alClient
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        DesignSize = (
          526
          155)
        object ListView1: TVDTListView
          Left = 2
          Top = 2
          Width = 501
          Height = 153
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelKind = bkTile
          Columns = <
            item
              AutoSize = True
              Caption = 'Album'
            end
            item
              Caption = 'Date'
              Width = 74
            end
            item
              Caption = 'Mvt'
              Width = 46
            end>
          RowSelect = True
          TabOrder = 1
          OnDblClick = ListView1DblClick
          OnSelectItem = ListView1SelectItem
        end
        object Panel9: TPanel
          Left = 505
          Top = 0
          Width = 21
          Height = 155
          Align = alRight
          AutoSize = True
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 0
          object VDTButton2: TCRFurtifLight
            Left = 0
            Top = 0
            Width = 21
            Height = 20
            Cursor = crHandPoint
            Glyph.Data = {
              360C0000424D360C000000000000360000002800000040000000100000000100
              180000000000000C0000120B0000120B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFB9C1BC9CABA0859A896F89747C928091A395A8B4ABBFC5C2D3D4
              D6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFD4D9D6C2CBC5B5C1B7A7B7AAAFBCB2BCC7BECAD1CBD7DBD9E3E4E5FF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB9C1BC9CABA0859A896F89747C
              928091A395A8B4ABBFC5C2D3D4D6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              B5BEB82F5935073C0D08460F0C65170F741A0F6B190D64170B5413073C0D1143
              178C9E90FF00FFFF00FFFF00FFFF00FFFF00FFB9C1BC9CABA0859A896F89747C
              928091A395A8B4ABBFC5C2D3D4D6FF00FFFF00FFFF00FFFF00FFFF00FFD1D7D3
              819A8569896D6A8F6E6CA1736EAA746EA5746DA1736B977069896D6F8D73B9C4
              BBFF00FFFF00FFFF00FFFF00FFB5BEB82F5935073C0D08460F0C65170F741A0F
              6B190D64170B5413073C0D1143178C9E90FF00FFFF00FFFF00FFFF00FFFF00FF
              547659073C0D11831E118C20118E20159E2518AF2A18AF2A18AF2A1497240A4E
              12124518FF00FFFF00FFFF00FFB5BEB82F5935073C0D08460F0C65170F741A0F
              6B190D64170B5413073C0D1143178C9E90FF00FFFF00FFFF00FFFF00FF97AC9A
              69896D6FB3776FB9786FBA7871C47B73CE7E73CE7E73CE7E71BF7A6B9470708E
              73FF00FFFF00FFFF00FFFF00FF547659073C0D11831E118C20118E20159E2518
              AF2A18AF2A18AF2A1497240A4E12124518FF00FFFF00FFFF00FFFF00FFFF00FF
              98A89C073C0D118920118C2016A62718AF2A18AF2A18AF2A70CD7B3DB34B0842
              0E638068FF00FFFF00FFFF00FF547659073C0D11831E118C20118E20159E2518
              AF2A18AF2A18AF2A1497240A4E12124518FF00FFFF00FFFF00FFFF00FFC0CAC2
              69896D6FB7786FB97872C87C73CE7E73CE7E73CE7EA8E0AF89D0926A8C6DA0B2
              A3FF00FFFF00FFFF00FFFF00FF98A89C073C0D118920118C2016A62718AF2A18
              AF2A18AF2A70CD7B3DB34B08420E638068FF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF55765A094810129021149E2518AF2A18AF2A29B53AABE2B10E5D172653
              2CCFD1D2FF00FFFF00FFFF00FF98A89C073C0D118920118C2016A62718AF2A18
              AF2A18AF2A70CD7B3DB34B08420E638068FF00FFFF00FFFF00FFFF00FFFF00FF
              98AC9B6A906E70BB7971C47B73CE7E73CE7E7DD188CBECCF6D9D737C977FE1E2
              E3FF00FFFF00FFFF00FFFF00FFFF00FF55765A094810129021149E2518AF2A18
              AF2A29B53AABE2B10E5D1726532CCFD1D2FF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFD0D2D32F59350B5B15128F2118AC2918AF2A60C86C188126093D0FA9B4
              ACFF00FFFF00FFFF00FFFF00FFFF00FF55765A094810129021149E2518AF2A18
              AF2A29B53AABE2B10E5D1726532CCFD1D2FF00FFFF00FFFF00FFFF00FFFF00FF
              E2E3E3819A856B9B7170BB7973CC7D73CE7E9EDDA673B27C6A896ECAD1CCFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFD0D2D32F59350B5B15128F2118AC2918
              AF2A60C86C188126093D0FA9B4ACFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFC7CBCA38603D0A4D11128D2118AF2A1A8928073D0D718B75FF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFD0D2D32F59350B5B15128F2118AC2918
              AF2A60C86C188126093D0FA9B4ACFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFDCDFDE869E896B936F70B97973CE7E74B77D69896DA9B8ABFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC7CBCA38603D0A4D11128D2118
              AF2A1A8928073D0D718B75FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFD1D3D451735508400E0A5012073C0D5D7C63FF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC7CBCA38603D0A4D11128D2118
              AF2A1A8928073D0D718B75FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFE2E3E495AA986A8B6D6B957069896D9DAFA0FF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD1D3D451735508400E0A
              5012073C0D5D7C63FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FF6D88721345196D8771FF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD1D3D451735508400E0A
              5012073C0D5D7C63FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFA6B6A9708E74A6B6A9FF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6D887213
              45196D8771FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6D887213
              45196D8771FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            NumGlyphs = 4
            OnClick = ToolButton1Click
          end
          object VDTButton3: TCRFurtifLight
            Left = 0
            Top = 20
            Width = 21
            Height = 21
            Cursor = crHandPoint
            Glyph.Data = {
              360C0000424D360C000000000000360000002800000040000000100000000100
              180000000000000C0000120B0000120B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FF6D88721345196D8771FF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFA6B6A9708E74A6B6A9FF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6D887213
              45196D8771FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFD1D3D451735508400E0A5012073C0D5D7C63FF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6D887213
              45196D8771FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFE2E3E495AA986A8B6D6B957069896D9DAFA0FF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD1D3D451735508400E0A
              5012073C0D5D7C63FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFC7CBCA38603D0A4D11128D2118AF2A1A8928073D0D718B75FF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD1D3D451735508400E0A
              5012073C0D5D7C63FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFDCDFDE869E896B936F70B97973CE7E74B77D69896DA9B8ABFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC7CBCA38603D0A4D11128D2118
              AF2A1A8928073D0D718B75FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFD0D2D32F59350B5B15128F2118AC2918AF2A60C86C188126093D0FA9B4
              ACFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC7CBCA38603D0A4D11128D2118
              AF2A1A8928073D0D718B75FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              E2E3E3819A856B9B7170BB7973CC7D73CE7E9EDDA673B27C6A896ECAD1CCFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFD0D2D32F59350B5B15128F2118AC2918
              AF2A60C86C188126093D0FA9B4ACFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF55765A094810129021149E2518AF2A18AF2A29B53AABE2B10E5D172653
              2CCFD1D2FF00FFFF00FFFF00FFFF00FFD0D2D32F59350B5B15128F2118AC2918
              AF2A60C86C188126093D0FA9B4ACFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              98AC9B6A906E70BB7971C47B73CE7E73CE7E7DD188CBECCF6D9D737C977FE1E2
              E3FF00FFFF00FFFF00FFFF00FFFF00FF55765A094810129021149E2518AF2A18
              AF2A29B53AABE2B10E5D1726532CCFD1D2FF00FFFF00FFFF00FFFF00FFFF00FF
              98A89C073C0D118920118C2016A62718AF2A18AF2A18AF2A70CD7B3DB34B0842
              0E638068FF00FFFF00FFFF00FFFF00FF55765A094810129021149E2518AF2A18
              AF2A29B53AABE2B10E5D1726532CCFD1D2FF00FFFF00FFFF00FFFF00FFC0CAC2
              69896D6FB7786FB97872C87C73CE7E73CE7E73CE7EA8E0AF89D0926A8C6DA0B2
              A3FF00FFFF00FFFF00FFFF00FF98A89C073C0D118920118C2016A62718AF2A18
              AF2A18AF2A70CD7B3DB34B08420E638068FF00FFFF00FFFF00FFFF00FFFF00FF
              547659073C0D11831E118C20118E20159E2518AF2A18AF2A18AF2A1497240A4E
              12124518FF00FFFF00FFFF00FF98A89C073C0D118920118C2016A62718AF2A18
              AF2A18AF2A70CD7B3DB34B08420E638068FF00FFFF00FFFF00FFFF00FF97AC9A
              69896D6FB3776FB9786FBA7871C47B73CE7E73CE7E73CE7E71BF7A6B9470708E
              73FF00FFFF00FFFF00FFFF00FF547659073C0D11831E118C20118E20159E2518
              AF2A18AF2A18AF2A1497240A4E12124518FF00FFFF00FFFF00FFFF00FFFF00FF
              B5BEB82F5935073C0D08460F0C65170F741A0F6B190D64170B5413073C0D1143
              178C9E90FF00FFFF00FFFF00FF547659073C0D11831E118C20118E20159E2518
              AF2A18AF2A18AF2A1497240A4E12124518FF00FFFF00FFFF00FFFF00FFD1D7D3
              819A8569896D6A8F6E6CA1736EAA746EA5746DA1736B977069896D6F8D73B9C4
              BBFF00FFFF00FFFF00FFFF00FFB5BEB82F5935073C0D08460F0C65170F741A0F
              6B190D64170B5413073C0D1143178C9E90FF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFB9C1BC9CABA0859A896F89747C928091A395A8B4ABBFC5C2D3D4
              D6FF00FFFF00FFFF00FFFF00FFB5BEB82F5935073C0D08460F0C65170F741A0F
              6B190D64170B5413073C0D1143178C9E90FF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFD4D9D6C2CBC5B5C1B7A7B7AAAFBCB2BCC7BECAD1CBD7DBD9E3E4E5FF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB9C1BC9CABA0859A896F89747C
              928091A395A8B4ABBFC5C2D3D4D6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB9C1BC9CABA0859A896F89747C
              928091A395A8B4ABBFC5C2D3D4D6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            NumGlyphs = 4
            OnClick = ToolButton4Click
          end
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 155
        Width = 526
        Height = 28
        Align = alBottom
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = ' '
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        object Label3: TLabel
          Left = 7
          Top = 7
          Width = 30
          Height = 13
          Hint = 'Date du mouvement'
          Caption = 'Date :'
          Layout = tlCenter
        end
        object lccEditions: TLightComboCheck
          Left = 205
          Top = 4
          Width = 300
          Height = 20
          Checked = False
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          PropertiesStored = False
          CheckVisible = False
          OnChange = lccEditionsChange
          ShowCaptionHint = False
          AssignHint = False
          OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
          Items.CaptionComplet = True
          Items.Separateur = ' '
          Items = <>
        end
        object pret: TCheckBoxLabeled
          Left = 141
          Top = 5
          Width = 38
          Height = 19
          Hint = 'Case coch'#233'e = le mouvement est un emprunt'
          Caption = 'Pr'#234't'
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          TabOrder = 1
          OnClick = pretClick
          LinkControls = <
            item
              Control = pret
            end>
        end
        object date_pret: TDateTimePickerLabeled
          Left = 34
          Top = 4
          Width = 93
          Height = 22
          Hint = 'Date du mouvement'
          CalColors.BackColor = clScrollBar
          Date = 36293.507726388900000000
          Time = 36293.507726388900000000
          Enabled = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnChange = date_pretChange
          LinkControls = <
            item
              Control = Label3
            end>
        end
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 526
      Height = 23
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Caption = ' '
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      object Label2: TLabel
        Left = 2
        Top = 2
        Width = 522
        Height = 19
        Align = alClient
        AutoSize = False
        ExplicitWidth = 521
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 23
      Width = 526
      Height = 149
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel6'
      TabOrder = 1
      DesignSize = (
        526
        149)
      object vtAlbums: TVirtualStringTree
        Left = 0
        Top = 24
        Width = 526
        Height = 125
        Align = alBottom
        AnimationDuration = 0
        BevelKind = bkTile
        BorderStyle = bsNone
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
        HintAnimation = hatNone
        HintMode = hmTooltip
        HotCursor = crHandPoint
        Indent = 8
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TreeOptions.PaintOptions = [toHotTrack, toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.StringOptions = [toSaveCaptions]
        OnDblClick = vtAlbumsDblClick
        Columns = <
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
            Position = 0
            Width = 526
          end>
      end
      inline FrameRechercheRapide1: TframRechercheRapide
        Left = 0
        Top = 2
        Width = 525
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        ExplicitTop = 2
        ExplicitWidth = 525
        inherited btNext: TVDTButton
          Left = 484
          ExplicitLeft = 484
        end
        inherited btNew: TVDTButton
          Left = 504
          ExplicitLeft = 504
        end
        inherited edSearch: TEditLabeled
          Width = 485
          ExplicitWidth = 485
        end
      end
    end
  end
  inline Frame11: TframBoutons
    Left = 0
    Top = 358
    Width = 526
    Height = 31
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 358
    ExplicitWidth = 526
    ExplicitHeight = 31
    inherited btnOK: TButton
      Left = 371
      Top = 6
      Width = 73
      Caption = 'Ok'
      Enabled = False
      OnClick = BtnOkExecute
      ExplicitLeft = 371
      ExplicitTop = 6
      ExplicitWidth = 73
    end
    inherited btnAnnuler: TButton
      Left = 451
      Top = 6
      Width = 72
      ExplicitLeft = 451
      ExplicitTop = 6
      ExplicitWidth = 72
    end
  end
end
