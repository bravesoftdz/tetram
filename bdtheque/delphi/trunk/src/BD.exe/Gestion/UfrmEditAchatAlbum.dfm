object frmEditAchatAlbum: TfrmEditAchatAlbum
  Left = 245
  Top = 418
  Caption = 'Achat'
  ClientHeight = 404
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label28: TLabel
    Left = 8
    Top = 4
    Width = 54
    Height = 23
    Caption = 'Achat'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 0
    Top = 29
    Width = 760
    Height = 4
    Align = alTop
    Shape = bsBottomLine
    ExplicitLeft = -88
    ExplicitWidth = 824
  end
  inline Frame11: TframBoutons
    Left = 0
    Top = 0
    Width = 760
    Height = 29
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 760
    inherited btnOK: TButton
      Left = 581
      Width = 87
      Caption = 'Enregistrer'
      OnClick = Frame11btnOKClick
      ExplicitLeft = 581
      ExplicitWidth = 87
    end
    inherited btnAnnuler: TButton
      Left = 677
      Width = 72
      ExplicitLeft = 677
      ExplicitWidth = 72
    end
  end
  object pnlForm: TScrollBox
    Left = 0
    Top = 33
    Width = 760
    Height = 371
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    DesignSize = (
      760
      371)
    object rbAlbumExistant: TRadioButton
      Left = 18
      Top = 23
      Width = 116
      Height = 17
      Caption = 'Album existant'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = rbNouvelAlbumClick
    end
    object rbNouvelAlbum: TRadioButton
      Left = 18
      Top = 66
      Width = 95
      Height = 17
      Caption = 'Nouvel album'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      TabStop = True
      OnClick = rbNouvelAlbumClick
    end
    object pnAlbumExistant: TPanel
      Left = 136
      Top = 19
      Width = 617
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = ' '
      TabOrder = 1
      DesignSize = (
        617
        23)
      inline vtEditAlbums: TframVTEdit
        Left = 1
        Top = 1
        Width = 615
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        ExplicitLeft = 1
        ExplicitTop = 1
        ExplicitWidth = 615
        inherited btReset: TVDTButton
          Left = 552
          ExplicitLeft = 617
        end
        inherited btNew: TVDTButton
          Left = 594
          ExplicitLeft = 659
        end
        inherited btEdit: TVDTButton
          Left = 573
          ExplicitLeft = 638
        end
        inherited VTEdit: TJvComboEdit
          Width = 552
          ExplicitWidth = 552
        end
      end
    end
    object pnNouvelAlbum: TPanel
      Left = 136
      Top = 64
      Width = 620
      Height = 292
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 2
      DesignSize = (
        620
        292)
      object Label2: TLabel
        Left = 14
        Top = 3
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = ' Titre :'
        FocusControl = edTitre
        Layout = tlCenter
      end
      object Label20: TLabel
        Left = 15
        Top = 26
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = 'S'#233'rie :'
      end
      object Label1: TLabel
        Left = 10
        Top = 50
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = ' Tome :'
        FocusControl = edTome
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 117
        Top = 50
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = ' Parution :'
        FocusControl = edAnneeParution
        Layout = tlCenter
      end
      object Label17: TLabel
        Left = 503
        Top = 50
        Width = 6
        Height = 13
        Alignment = taRightJustify
        Caption = #224
        FocusControl = edTomeFin
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInactiveCaption
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object Label6: TLabel
        Left = 3
        Top = 73
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = 'Histoire :'
        FocusControl = histoire
      end
      object Label7: TLabel
        Left = 293
        Top = 73
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = 'Notes :'
        FocusControl = remarques
        ExplicitLeft = 353
      end
      object btScenariste: TVDTButton
        Tag = 1
        Left = 334
        Top = 157
        Width = 69
        Height = 41
        Anchors = [akTop, akRight]
        Caption = 'Sc'#233'nariste'
        Enabled = False
        Layout = blGlyphBottom
        OnClick = btScenaristeClick
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000001924944415478DA
          A593CF2B445114C7BFF7CD9B9937C3F363A8998D29358AB0D26C98291B4B2294
          85B261C972E41FB0100BAC44898D1FD9B04191321E121B56A4484D340B63E6CD
          AF37EFC77567AC14CF4CBE75EB9CFBED7C3A9D7B0FC13F454C3C8E1DA3744027
          0451B31D33CB4D29194B4AD99392001501FB0405E6052F8FEC8BC6422CF38212
          8A1D215E14A0BCC3BEE0A8B78E7B06AAE0FDF041DAB8849EA2118E1ABD7149BD
          2EA20361DBD5E31CAC6E1431E75FC2C1F31E5617D7F2DD2409C14022AC1C9A02
          C480FDD4332C06AD6EBE903755B640D70D48EB57C83EA92A285A6549B937033C
          78462A1AACB5966FF74A44437453CE8733F29932690678ABE973BA1D753610EB
          97ADC906129719A46E73119D58FCE970FAD504205CBBBA1D6D7CA5057C190735
          A1437BD7113BCC643818C1F8997A633E830EFB8ED82EF4DBDC5C21A71A416C3F
          0543A3434929B7F5E72B8841619A7362AABACB815C54877CAE5036B8101BDC6C
          91FFC0D64C08B9630E618549103A2C8773BBF8453FEE02EB629415FB884E5712
          17CA234C64B64C45E9DF804F400D9711AB9FEB370000000049454E44AE426082}
        ExplicitLeft = 394
      end
      object btDessinateur: TVDTButton
        Tag = 2
        Left = 334
        Top = 201
        Width = 69
        Height = 41
        Anchors = [akTop, akRight]
        Caption = 'Dessinateur'
        Enabled = False
        Layout = blGlyphBottom
        OnClick = btScenaristeClick
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000001924944415478DA
          A593CF2B445114C7BFF7CD9B9937C3F363A8998D29358AB0D26C98291B4B2294
          85B261C972E41FB0100BAC44898D1FD9B04191321E121B56A4484D340B63E6CD
          AF37EFC77567AC14CF4CBE75EB9CFBED7C3A9D7B0FC13F454C3C8E1DA3744027
          0451B31D33CB4D29194B4AD99392001501FB0405E6052F8FEC8BC6422CF38212
          8A1D215E14A0BCC3BEE0A8B78E7B06AAE0FDF041DAB8849EA2118E1ABD7149BD
          2EA20361DBD5E31CAC6E1431E75FC2C1F31E5617D7F2DD2409C14022AC1C9A02
          C480FDD4332C06AD6EBE903755B640D70D48EB57C83EA92A285A6549B937033C
          78462A1AACB5966FF74A44437453CE8733F29932690678ABE973BA1D753610EB
          97ADC906129719A46E73119D58FCE970FAD504205CBBBA1D6D7CA5057C190735
          A1437BD7113BCC643818C1F8997A633E830EFB8ED82EF4DBDC5C21A71A416C3F
          0543A3434929B7F5E72B8841619A7362AABACB815C54877CAE5036B8101BDC6C
          91FFC0D64C08B9630E618549103A2C8773BBF8453FEE02EB629415FB884E5712
          17CA234C64B64C45E9DF804F400D9711AB9FEB370000000049454E44AE426082}
        ExplicitLeft = 394
      end
      object btColoriste: TVDTButton
        Tag = 3
        Left = 334
        Top = 245
        Width = 69
        Height = 41
        Anchors = [akTop, akRight]
        Caption = 'Coloriste'
        Enabled = False
        Layout = blGlyphBottom
        OnClick = btScenaristeClick
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000001924944415478DA
          A593CF2B445114C7BFF7CD9B9937C3F363A8998D29358AB0D26C98291B4B2294
          85B261C972E41FB0100BAC44898D1FD9B04191321E121B56A4484D340B63E6CD
          AF37EFC77567AC14CF4CBE75EB9CFBED7C3A9D7B0FC13F454C3C8E1DA3744027
          0451B31D33CB4D29194B4AD99392001501FB0405E6052F8FEC8BC6422CF38212
          8A1D215E14A0BCC3BEE0A8B78E7B06AAE0FDF041DAB8849EA2118E1ABD7149BD
          2EA20361DBD5E31CAC6E1431E75FC2C1F31E5617D7F2DD2409C14022AC1C9A02
          C480FDD4332C06AD6EBE903755B640D70D48EB57C83EA92A285A6549B937033C
          78462A1AACB5966FF74A44437453CE8733F29932690678ABE973BA1D753610EB
          97ADC906129719A46E73119D58FCE970FAD504205CBBBA1D6D7CA5057C190735
          A1437BD7113BCC643818C1F8997A633E830EFB8ED82EF4DBDC5C21A71A416C3F
          0543A3434929B7F5E72B8841619A7362AABACB815C54877CAE5036B8101BDC6C
          91FFC0D64C08B9630E618549103A2C8773BBF8453FEE02EB629415FB884E5712
          17CA234C64B64C45E9DF804F400D9711AB9FEB370000000049454E44AE426082}
        ExplicitLeft = 394
      end
      object Label19: TLabel
        Left = 1
        Top = 214
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'Auteurs :'
      end
      object Label16: TLabel
        Left = 414
        Top = 50
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = 'Tomes :'
        FocusControl = edTomeDebut
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInactiveCaption
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object edTitre: TEditLabeled
        Left = 52
        Top = 0
        Width = 568
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        LinkControls = <
          item
            Control = Label2
          end>
        CurrencyChar = #0
      end
      inline vtEditSeries: TframVTEdit
        Left = 52
        Top = 23
        Width = 568
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        ExplicitLeft = 52
        ExplicitTop = 23
        ExplicitWidth = 568
        inherited btReset: TVDTButton
          Left = 505
          ExplicitLeft = 565
        end
        inherited btNew: TVDTButton
          Left = 547
          ExplicitLeft = 607
        end
        inherited btEdit: TVDTButton
          Left = 526
          ExplicitLeft = 586
        end
        inherited VTEdit: TJvComboEdit
          Width = 505
          OnChange = vtEditSeriesVTEditChange
          ExplicitWidth = 505
        end
      end
      object edTome: TEditLabeled
        Left = 52
        Top = 47
        Width = 39
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 3
        TabOrder = 2
        LinkControls = <
          item
            Control = Label1
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edMoisParution: TEditLabeled
        Left = 173
        Top = 47
        Width = 22
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 2
        TabOrder = 3
        LinkControls = <
          item
            Control = Label3
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edAnneeParution: TEditLabeled
        Left = 201
        Top = 47
        Width = 39
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 4
        LinkControls = <
          item
            Control = Label3
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object cbHorsSerie: TCheckBoxLabeled
        Left = 264
        Top = 49
        Width = 73
        Height = 16
        Cursor = crHandPoint
        Caption = 'Hors s'#233'rie'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 5
        LinkControls = <
          item
            Control = cbHorsSerie
          end>
      end
      object cbIntegrale: TCheckBoxLabeled
        Left = 343
        Top = 49
        Width = 65
        Height = 16
        Cursor = crHandPoint
        Caption = 'Int'#233'grale'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 6
        OnClick = cbIntegraleClick
        LinkControls = <
          item
            Control = cbIntegrale
          end>
      end
      object edTomeDebut: TEditLabeled
        Left = 458
        Top = 47
        Width = 39
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 3
        TabOrder = 7
        LinkControls = <
          item
            Control = Label16
          end
          item
            Control = Label17
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edTomeFin: TEditLabeled
        Left = 515
        Top = 47
        Width = 39
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 3
        TabOrder = 8
        LinkControls = <
          item
            Control = Label16
          end
          item
            Control = Label17
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object histoire: TMemoLabeled
        Left = 52
        Top = 70
        Width = 235
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        ScrollBars = ssVertical
        TabOrder = 9
        LinkControls = <
          item
            Control = Label6
          end>
      end
      object remarques: TMemoLabeled
        Left = 334
        Top = 70
        Width = 287
        Height = 81
        Anchors = [akTop, akRight]
        BevelKind = bkTile
        BorderStyle = bsNone
        ScrollBars = ssVertical
        TabOrder = 10
        LinkControls = <
          item
            Control = Label7
          end>
      end
      object lvScenaristes: TVDTListViewLabeled
        Left = 409
        Top = 157
        Width = 212
        Height = 41
        Anchors = [akTop, akRight]
        BevelKind = bkTile
        Columns = <
          item
          end>
        OwnerData = True
        SortType = stNone
        TabOrder = 12
        OnData = lvScenaristesData
        OnKeyDown = lvColoristesKeyDown
        LinkControls = <
          item
            Control = btScenariste
          end>
      end
      object lvDessinateurs: TVDTListViewLabeled
        Left = 409
        Top = 201
        Width = 212
        Height = 41
        Anchors = [akTop, akRight]
        BevelKind = bkTile
        Columns = <
          item
          end>
        OwnerData = True
        SortType = stBoth
        TabOrder = 13
        OnData = lvDessinateursData
        OnKeyDown = lvColoristesKeyDown
        LinkControls = <
          item
            Control = btDessinateur
          end>
      end
      object lvColoristes: TVDTListViewLabeled
        Left = 409
        Top = 245
        Width = 212
        Height = 41
        Anchors = [akTop, akRight]
        BevelKind = bkTile
        Columns = <
          item
          end>
        OwnerData = True
        SortType = stBoth
        TabOrder = 14
        OnData = lvColoristesData
        OnKeyDown = lvColoristesKeyDown
        LinkControls = <
          item
            Control = btColoriste
          end>
      end
      inline vtEditPersonnes: TframVTEdit
        Left = 52
        Top = 211
        Width = 235
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 11
        ExplicitLeft = 52
        ExplicitTop = 211
        ExplicitWidth = 235
        inherited btReset: TVDTButton
          Left = 172
          ExplicitLeft = 232
        end
        inherited btNew: TVDTButton
          Left = 214
          ExplicitLeft = 274
        end
        inherited btEdit: TVDTButton
          Left = 193
          ExplicitLeft = 253
        end
        inherited VTEdit: TJvComboEdit
          Width = 172
          OnChange = vtEditPersonnesVTEditChange
          ExplicitWidth = 172
        end
      end
    end
  end
  object btnScript: TButton
    Left = 33
    Top = 122
    Width = 69
    Height = 21
    Cursor = crHandPoint
    Hint = 'Valider les modifcations'
    Caption = 'Script'
    Default = True
    DoubleBuffered = True
    ImageIndex = 12
    Images = dmPrinc.ShareImageList
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = btnScriptClick
  end
end
