object frmEditUnivers: TfrmEditUnivers
  Left = 302
  Top = 146
  ActiveControl = edNom
  Caption = 'Saisie d'#39'Univers'
  ClientHeight = 920
  ClientWidth = 798
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 29
    Width = 798
    Height = 4
    Align = alTop
    Shape = bsBottomLine
    ExplicitTop = 25
    ExplicitWidth = 742
  end
  object Label28: TLabel
    Left = 8
    Top = 4
    Width = 72
    Height = 23
    Caption = 'Univers'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 33
    Width = 798
    Height = 887
    Align = alClient
    BorderStyle = bsNone
    Constraints.MinWidth = 650
    TabOrder = 0
    DesignSize = (
      798
      887)
    object Label2: TLabel
      Left = 62
      Top = 7
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Nom :'
      FocusControl = edNom
      Layout = tlCenter
    end
    object Bevel2: TBevel
      Left = 165
      Top = 186
      Width = 467
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label6: TLabel
      Left = 30
      Top = 59
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Caption = 'Description :'
      FocusControl = edDescription
    end
    object VDTButton13: TVDTButton
      Left = 769
      Top = 30
      Width = 23
      Height = 20
      Anchors = [akTop, akRight]
      Enabled = False
      OnClick = VDTButton13Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000000473424954080808087C0864880000001974455874536F6674776172
        65007777772E696E6B73636170652E6F72679BEE3C1A000003604944415478DA
        6D537F6C535514FEEE7BFDF1FACBAD5B07ED5A2863EB3612602CB18B46171323
        9943428C1223930C220A26265333FD47130D31C699A09300662E189C193131F8
        63401490B0C505C600C5CD76736B29DD5CC72CA5EB3ADA3DFBFADEF3BCC61045
        4EF2E5E4DE9CF39D73BF7B0EC33DACB6F1E915E4FC843A4294709930FEFBE0D7
        F2DDB1ECAEC46A723D8407B4B30A9681AA981999AA28F1BC24BE7CEDD20FC7EE
        4940C9ADAAAA76398A8DAC65E746355BF58C7183D3C299988C6BB337B3C70E77
        A742A3A3E5F99CF855EA46645B627A5CB94340C96BC9FDB2F9C152DDBBAD6E26
        783662545D0796071C46154BCC060307EC3F31143F71705F99B898FC786A64A0
        5D6B9251B28E2A0F5738850D7DEFACE20CB695504AD7E3C7C53AD4F131945919
        7E16AB709F0E05923D7B0F86FFB8D8BF223933D97C331AE8D7081A89E9A79ED7
        BD68A831432DAEC597E226DCCF4DC1674A01A6629C595C0F0BCFC1A607CEDD90
        F0E94B2D8B4B0B89E3D32303BB358257F43CFBE8D227F59C8102BE655B3034EF
        4387FB34789E07138AF14DDA0F8E1960A32EA219E0C3F6B689DC6C384D826E65
        350F3F75C4E7B66C5FF3DCABBA8E9AEF71DBEE455BE45994A839D4B3592C33AB
        98142AE114647A868AAB2986DE035D63D268FFF2C9F3DF3DCAAA1F7AB253108C
        2F18DFE8B50E79DFA7AA32AEE81BF05E6C138AA8A306FB3C76BB7E852E478A6A
        BA2F05D17E282C9D1C9C894E5EE8DBA975D042DF7C54683F82A3F62FB066F91C
        92B62A34057714DEBCDD1DC12EC359D29B0872B7C8E7B065EF941C0CC54F45AE
        9C7E4BD3A0827E21CCFB9BE3D6A61DCE2EA107E3561FF6251F29CC87C320E28C
        B71381693B248543787A5E79FBF065359D9839303B3EBCBF300795FEC7BB7582
        E579E3AE0F24BEBC5230CB22B2BC5020F09832E82BEF446B701B02BC0762E78B
        734A369D085D3CF9A6AAC8030502578DDF622D71FDC6E90D4EFD137BB2FAFAC7
        4AB5FB6AF32D7CBEB2174236819EA047E9E81E8EAB9905FB9FE1ABAFA5E6AE0F
        68FB716794CB2AD6F96C0EF76706C1D28822478CF7AECD35572B2E8F183206AE
        67717E6C4195657922110D1E4AC642014A192428FF5926B2A2F2DA863693ADA4
        893708AB398E77913EF34A5E9AF82B9B1E99095E38A5C85284E2C608F9FF6DE3
        3F46038B558452BD6059268919EDEE3681C6123142E2DFC17F03DFC55B0C5750
        2E1C0000000049454E44AE426082}
    end
    object Label1: TLabel
      Left = 42
      Top = 33
      Width = 48
      Height = 13
      Hint = 'R'#233'f'#233'rence du support'
      Alignment = taRightJustify
      Caption = 'Site web :'
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 49
      Top = 198
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Albums :'
    end
    object Label4: TLabel
      Left = 44
      Top = 367
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = 'Para-BD :'
    end
    object Label10: TLabel
      Left = 24
      Top = 481
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'Associations :'
      FocusControl = edAssociations
      Transparent = True
      Layout = tlCenter
    end
    object Bevel4: TBevel
      Left = 165
      Top = 469
      Width = 467
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label5: TLabel
      Left = 12
      Top = 146
      Width = 78
      Height = 13
      Alignment = taRightJustify
      Caption = 'Univers parent :'
    end
    object edNom: TEditLabeled
      Left = 96
      Top = 4
      Width = 696
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      OnChange = edNomChange
      LinkControls = <
        item
          Control = Label2
        end>
      CurrencyChar = #0
    end
    object edDescription: TMemoLabeled
      Left = 96
      Top = 56
      Width = 696
      Height = 81
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 2
      LinkControls = <
        item
          Control = Label6
        end>
    end
    object vtAlbums: TVirtualStringTree
      Left = 96
      Top = 198
      Width = 696
      Height = 163
      Anchors = [akLeft, akTop, akRight]
      AnimationDuration = 0
      BevelKind = bkTile
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      HintAnimation = hatNone
      HintMode = hmTooltip
      HotCursor = crHandPoint
      Indent = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnDblClick = vtAlbumsDblClick
      Columns = <>
    end
    object edSite: TEditLabeled
      Left = 96
      Top = 30
      Width = 672
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      BevelKind = bkTile
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      OnChange = edSiteChange
      LinkControls = <
        item
          Control = Label1
        end>
      CurrencyChar = #0
    end
    object vtParaBD: TVirtualStringTree
      Left = 96
      Top = 367
      Width = 696
      Height = 96
      Anchors = [akLeft, akTop, akRight]
      AnimationDuration = 0
      BevelKind = bkTile
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      HintAnimation = hatNone
      HintMode = hmTooltip
      HotCursor = crHandPoint
      Indent = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnDblClick = vtParaBDDblClick
      Columns = <>
    end
    object edAssociations: TMemoLabeled
      Left = 96
      Top = 478
      Width = 696
      Height = 105
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      ScrollBars = ssBoth
      TabOrder = 6
      WordWrap = False
      LinkControls = <
        item
          Control = Label10
        end>
    end
    inline vtEditUnivers: TframVTEdit
      Left = 96
      Top = 143
      Width = 696
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      ExplicitLeft = 96
      ExplicitTop = 143
      ExplicitWidth = 696
      inherited btReset: TVDTButton
        Left = 633
        ExplicitLeft = 284
      end
      inherited btNew: TVDTButton
        Left = 675
        ExplicitLeft = 326
      end
      inherited btEdit: TVDTButton
        Left = 654
        ExplicitLeft = 305
      end
      inherited VTEdit: TJvComboEdit
        Width = 633
        ExplicitWidth = 633
      end
    end
  end
  inline Frame11: TframBoutons
    Left = 0
    Top = 0
    Width = 798
    Height = 29
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 798
    inherited btnOK: TButton
      Left = 624
      Width = 90
      Caption = 'Enregistrer'
      OnClick = Frame11btnOKClick
      ExplicitLeft = 624
      ExplicitWidth = 90
    end
    inherited btnAnnuler: TButton
      Left = 715
      ExplicitLeft = 715
    end
  end
end
