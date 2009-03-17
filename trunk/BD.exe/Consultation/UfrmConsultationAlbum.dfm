object frmConsultationAlbum: TfrmConsultationAlbum
  Left = 440
  Top = 64
  Caption = 'Fiche d'#39'album'
  ClientHeight = 815
  ClientWidth = 522
  Color = clWhite
  Constraints.MinWidth = 530
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 0
    Width = 522
    Height = 815
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 0
    DesignSize = (
      522
      815)
    object Label4: TLabel
      Left = 364
      Top = 164
      Width = 89
      Height = 21
      Alignment = taCenter
      Anchors = [akTop, akRight]
      Caption = 'Pas d'#39'image'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object l_remarques: TLabel
      Left = 28
      Top = 392
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes'
      Color = clWhite
      FocusControl = remarques
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_sujet: TLabel
      Left = 20
      Top = 321
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Histoire'
      Color = clWhite
      FocusControl = sujet
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 22
      Top = 94
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Genres'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_annee: TLabel
      Left = 25
      Top = 11
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object l_acteurs: TLabel
      Left = 20
      Top = 176
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Dessins'
      Color = clWhite
      FocusControl = lvDessinateurs
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object l_realisation: TLabel
      Left = 15
      Top = 135
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = 'Scenario'
      Color = clWhite
      FocusControl = lvScenaristes
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 32
      Top = 259
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'S'#233'rie'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object TitreAlbum: TLabel
      Left = 59
      Top = 27
      Width = 455
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Titre'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
    end
    object Label6: TLabel
      Left = 27
      Top = 33
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Titre :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object VDTButton3: TCRFurtifLight
      Left = 471
      Top = 299
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
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
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFBAC1BD69846D869B
        8AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD4D9D6A4B4A6B5C2B8FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFBAC1BD69846D869B8AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF96A79A114317073D0D083D
        0EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFBAC1BD69846D869B8AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFBFC9C16F8D7369896D6A896DFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FF96A79A114317073D0D083D0EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF78907D083D0E0E761A118C200847
        0F6A866EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FF96A79A114317073D0D083D0EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFADBBB06A896D6DAC746FB9786A8F6EA4B5
        A7FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF78
        907D083D0E0E761A118C2008470F6A866EFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF90A294073F0E12881F118C20118C200F75
        1A4B6E50FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF78
        907D083D0E0E761A118C2008470F6A866EFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFBBC6BE698B6D70B6776FB9786FB9786EAB7492A7
        95FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF90A29407
        3F0E12881F118C20118C200F751A4B6E50FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFADB8B10E411410831E13952216A3271498231189
        1F315B36FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF90A29407
        3F0E12881F118C20118C200F751A4B6E50FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFCDD3CF6D8C716EB37770BE7972C77C71C07A6FB777829B
        85FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFADB8B10E411410
        831E13952216A32714982311891F315B36FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFC3C8C61D4C230D6A1816A22618AF2A18AF2A17AA29118D
        201A4A1FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFADB8B10E411410
        831E13952216A32714982311891F315B36FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFDADDDC76927A6DA47372C67C73CE7E73CE7E73CB7D6FB9787491
        77FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC3C8C61D4C230D6A1816
        A22618AF2A18AF2A17AA29118D201A4A1FFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF67846C073C0D14942318AF2A18AF2A18AF2A18AF2A159B
        2525522BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC3C8C61D4C230D6A1816
        A22618AF2A18AF2A17AA29118D201A4A1FFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFA3B4A669896D71BE7A73CE7E73CE7E73CE7E73CE7E71C27B7B96
        7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF67846C073C0D14942318
        AF2A18AF2A18AF2A18AF2A159B2525522BFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFB7BFBB0B3F110C5D1542BB5044BE5318AF2A18AF2A1498
        2539613EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF67846C073C0D14942318
        AF2A18AF2A18AF2A18AF2A159B2525522BFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFD3D7D56B8B6F6C9D718CD5958ED79773CE7E73CE7E71C07B879F
        8AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB7BFBB0B3F110C5D1542
        BB5044BE5318AF2A18AF2A14982539613EFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF9DACA11143170B5A156AC776B8E7BE1FB231128A
        204D7052FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB7BFBB0B3F110C5D1542
        BB5044BE5318AF2A18AF2A14982539613EFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFC3CCC56F8D736B9B71A4DCACD3EFD777D08270B87893A8
        96FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9DACA11143170B
        5A156AC776B8E7BE1FB231128A204D7052FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFACB7B11D4C2308471040A04B1CB02D0C5C
        15607E64FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9DACA11143170B
        5A156AC776B8E7BE1FB231128A204D7052FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFCCD3CF76927A6A8F6E8BC59276CE806C9C719EB0
        A1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFACB7B11D
        4C2308471040A04B1CB02D0C5C15607E64FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCACECE5A7A5F083D0E0B5A15073C
        0D7D9482FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFACB7B11D
        4C2308471040A04B1CB02D0C5C15607E64FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFDEE0E09BAE9E6A896D6B9B7169896DB0BE
        B3FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCA
        CECE5A7A5F083D0E0B5A15073C0D7D9482FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA2AFA5245129365F
        3CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCA
        CECE5A7A5F083D0E0B5A15073C0D7D9482FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC6CEC87A957D859E89FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFA2AFA5245129365F3CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFA2AFA5245129365F3CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
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
      Visible = False
      OnClick = VDTButton2Click
    end
    object VDTButton4: TCRFurtifLight
      Left = 495
      Top = 299
      Width = 21
      Height = 20
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
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
        FF00FFFF00FFFF00FFFF00FF869B8A69846DBAC1BDFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFB5C2B8A4B4A6D4D9D6FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF869B8A69846DBA
        C1BDFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF083D0E073D0D11431796A79AFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF869B8A69846DBA
        C1BDFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF6A896D69896D6F8D73BFC9C1FF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF083D0E073D0D11
        431796A79AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF6A866E08470F118C200E761A083D0E78907DFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF083D0E073D0D11
        431796A79AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFA4B5A76A8F6E6FB9786DAC746A896DADBBB0FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6A866E08470F118C200E
        761A083D0E78907DFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF4B6E500F751A118C20118C2012881F073F0E90A294FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6A866E08470F118C200E
        761A083D0E78907DFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF92A7956EAB746FB9786FB97870B677698B6DBBC6BEFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4B6E500F751A118C2011
        8C2012881F073F0E90A294FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF315B3611891F14982316A32713952210831E0E4114ADB8
        B1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4B6E500F751A118C2011
        8C2012881F073F0E90A294FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF829B856FB77771C07A72C77C70BE796EB3776D8C71CDD3CFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF315B3611891F14982316
        A32713952210831E0E4114ADB8B1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF1A4A1F118D2017AA2918AF2A18AF2A16A2260D6A181D4C
        23C3C8C6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF315B3611891F14982316
        A32713952210831E0E4114ADB8B1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF7491776FB97873CB7D73CE7E73CE7E72C67C6DA47376927ADADD
        DCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1A4A1F118D2017AA2918
        AF2A18AF2A16A2260D6A181D4C23C3C8C6FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF25522B159B2518AF2A18AF2A18AF2A18AF2A149423073C
        0D67846CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1A4A1F118D2017AA2918
        AF2A18AF2A16A2260D6A181D4C23C3C8C6FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF7B967F71C27B73CE7E73CE7E73CE7E73CE7E71BE7A69896DA3B4
        A6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF25522B159B2518AF2A18
        AF2A18AF2A18AF2A149423073C0D67846CFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF39613E14982518AF2A18AF2A44BE5342BB500C5D150B3F
        11B7BFBBFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF25522B159B2518AF2A18
        AF2A18AF2A18AF2A149423073C0D67846CFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF879F8A71C07B73CE7E73CE7E8ED7978CD5956C9D716B8B6FD3D7
        D5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF39613E14982518AF2A18
        AF2A44BE5342BB500C5D150B3F11B7BFBBFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF4D7052128A201FB231B8E7BE6AC7760B5A151143179DAC
        A1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF39613E14982518AF2A18
        AF2A44BE5342BB500C5D150B3F11B7BFBBFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF93A89670B87877D082D3EFD7A4DCAC6B9B716F8D73C3CCC5FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4D7052128A201FB231B8
        E7BE6AC7760B5A151143179DACA1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF607E640C5C151CB02D40A04B0847101D4C23ACB7B1FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4D7052128A201FB231B8
        E7BE6AC7760B5A151143179DACA1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF9EB0A16C9C7176CE808BC5926A8F6E76927ACCD3CFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF607E640C5C151CB02D40
        A04B0847101D4C23ACB7B1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF7D9482073C0D0B5A15083D0E5A7A5FCACECEFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF607E640C5C151CB02D40
        A04B0847101D4C23ACB7B1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFB0BEB369896D6B9B716A896D9BAE9EDEE0E0FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7D9482073C0D0B5A1508
        3D0E5A7A5FCACECEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF365F3C245129A2AFA5FF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7D9482073C0D0B5A1508
        3D0E5A7A5FCACECEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF859E897A957DC6CEC8FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF365F3C245129A2
        AFA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF365F3C245129A2
        AFA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
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
      Visible = False
      OnClick = VDTButton1Click
    end
    object Label7: TLabel
      Left = 14
      Top = 218
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Couleurs'
      Color = clWhite
      FocusControl = lvColoristes
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label11: TLabel
      Left = 9
      Top = 67
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = 'Parution :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object AnneeParution: TLabel
      Left = 59
      Top = 67
      Width = 70
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Parution'
      Transparent = True
    end
    object TitreSerie: TLabel
      Left = 59
      Top = 5
      Width = 455
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'S'#233'rie'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
      Layout = tlCenter
      WordWrap = True
      OnClick = TitreSerieClick
      OnDblClick = TitreSerieDblClick
    end
    object Label14: TLabel
      Left = 23
      Top = 52
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = 'Tome :'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ShowAccelChar = False
      Transparent = True
    end
    object Tome: TLabel
      Left = 59
      Top = 52
      Width = 70
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Tome'
      Transparent = True
    end
    object Bevel1: TBevel
      Left = 0
      Top = 812
      Width = 522
      Height = 3
      Align = alBottom
      Shape = bsSpacer
    end
    object Label18: TLabel
      Left = 351
      Top = 204
      Width = 114
      Height = 42
      Alignment = taCenter
      Anchors = [akTop, akRight]
      Caption = 'Impossible de charger l'#39'image'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      Visible = False
      WordWrap = True
    end
    object Couverture: TImage
      Left = 301
      Top = 51
      Width = 215
      Height = 246
      Anchors = [akTop, akRight]
      Center = True
      IncrementalDisplay = True
    end
    object remarques: TMemo
      Left = 59
      Top = 392
      Width = 457
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 8
    end
    object sujet: TMemo
      Left = 59
      Top = 320
      Width = 457
      Height = 67
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 7
    end
    object lvScenaristes: TVDTListView
      Left = 59
      Top = 135
      Width = 233
      Height = 35
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      Color = clWhite
      Columns = <
        item
          MinWidth = 150
          Width = 231
        end>
      OwnerData = True
      TabOrder = 3
      OnData = lvScenaristesData
      OnDblClick = lvScenaristesDblClick
    end
    object lvDessinateurs: TVDTListView
      Left = 59
      Top = 176
      Width = 233
      Height = 36
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      Color = clWhite
      Columns = <
        item
          MinWidth = 150
          Width = 231
        end>
      OwnerData = True
      SortType = stData
      TabOrder = 4
      OnData = lvDessinateursData
      OnDblClick = lvScenaristesDblClick
    end
    object lvSerie: TVDTListView
      Left = 59
      Top = 259
      Width = 233
      Height = 56
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      Color = clWhite
      Columns = <
        item
          MinWidth = 140
          Width = 231
        end>
      OwnerData = True
      SmallImages = frmFond.ShareImageList
      SortType = stNone
      TabOrder = 6
      OnData = lvSerieData
      OnDblClick = lvSerieDblClick
      OnGetImageIndex = lvSerieGetImageIndex
    end
    object Memo1: TMemo
      Left = 59
      Top = 94
      Width = 233
      Height = 34
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object lvColoristes: TVDTListView
      Left = 59
      Top = 218
      Width = 233
      Height = 36
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelOuter = bvNone
      BevelKind = bkFlat
      Color = clWhite
      Columns = <
        item
          Width = 46
        end>
      OwnerData = True
      SortType = stData
      TabOrder = 5
      OnData = lvColoristesData
      OnDblClick = lvScenaristesDblClick
    end
    object Integrale: TReadOnlyCheckBox
      Left = 171
      Top = 50
      Width = 126
      Height = 16
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Int'#233'grale'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object HorsSerie: TReadOnlyCheckBox
      Left = 171
      Top = 65
      Width = 68
      Height = 16
      TabStop = False
      Caption = 'Hors s'#233'rie'
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
    object PanelEdition: TPanel
      Left = 3
      Top = 464
      Width = 513
      Height = 345
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      Caption = ' '
      ParentColor = True
      TabOrder = 9
      DesignSize = (
        513
        345)
      object ISBN: TLabel
        Left = 56
        Top = 2
        Width = 23
        Height = 13
        Caption = 'ISBN'
      end
      object Editeur: TLabel
        Left = 56
        Top = 18
        Width = 34
        Height = 13
        Caption = 'Editeur'
        ShowAccelChar = False
        OnClick = EditeurClick
      end
      object Prix: TLabel
        Left = 56
        Top = 52
        Width = 18
        Height = 13
        Caption = 'Prix'
      end
      object Lbl_numero: TLabel
        Left = 23
        Top = 2
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'ISBN :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Lbl_type: TLabel
        Left = 12
        Top = 18
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'Editeur :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label3: TLabel
        Left = 28
        Top = 52
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prix :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label2: TLabel
        Left = 14
        Top = 205
        Width = 45
        Height = 13
        Caption = 'Emprunts'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ShowAccelChar = False
        Transparent = True
      end
      object nbemprunts: TLabel
        Left = 71
        Top = 205
        Width = 3
        Height = 13
        Transparent = True
      end
      object Label9: TLabel
        Left = 0
        Top = 35
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'Collection :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Collection: TLabel
        Left = 56
        Top = 35
        Width = 46
        Height = 13
        Caption = 'Collection'
        ShowAccelChar = False
      end
      object Label16: TLabel
        Left = 262
        Top = 18
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ann'#233'e :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object AnneeEdition: TLabel
        Left = 305
        Top = 18
        Width = 31
        Height = 13
        Caption = 'Ann'#233'e'
      end
      object Etat: TLabel
        Left = 56
        Top = 85
        Width = 20
        Height = 13
        Caption = 'Etat'
        ShowAccelChar = False
      end
      object Label10: TLabel
        Left = 26
        Top = 85
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Etat :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Reliure: TLabel
        Left = 208
        Top = 85
        Width = 33
        Height = 13
        Caption = 'Reliure'
        ShowAccelChar = False
      end
      object Label13: TLabel
        Left = 160
        Top = 85
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Reliure :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object TypeEdition: TLabel
        Left = 350
        Top = 85
        Width = 32
        Height = 13
        Caption = 'Edition'
        ShowAccelChar = False
      end
      object Label8: TLabel
        Left = 18
        Top = 134
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'Notes :'
        Color = clWhite
        FocusControl = edNotes
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label12: TLabel
        Left = 148
        Top = 52
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = 'Achet'#233' le :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object AcheteLe: TLabel
        Left = 208
        Top = 52
        Width = 45
        Height = 13
        Caption = 'Achet'#233' le'
      end
      object Label15: TLabel
        Left = 17
        Top = 101
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = 'Pages :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Pages: TLabel
        Left = 56
        Top = 101
        Width = 29
        Height = 13
        Caption = 'Pages'
      end
      object Label17: TLabel
        Left = 139
        Top = 101
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = 'Orientation :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbOrientation: TLabel
        Left = 208
        Top = 101
        Width = 54
        Height = 13
        Caption = 'Orientation'
        ShowAccelChar = False
      end
      object Label19: TLabel
        Left = 350
        Top = 101
        Width = 41
        Height = 13
        Caption = 'Format :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbFormat: TLabel
        Left = 395
        Top = 101
        Width = 34
        Height = 13
        Caption = 'Format'
        ShowAccelChar = False
      end
      object lbCote: TLabel
        Left = 56
        Top = 68
        Width = 23
        Height = 13
        Caption = 'Cote'
      end
      object Label20: TLabel
        Left = 23
        Top = 68
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Cote :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Label21: TLabel
        Left = 119
        Top = 117
        Width = 81
        Height = 13
        Alignment = taRightJustify
        Caption = 'Sens de lecture :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbSensLecture: TLabel
        Left = 208
        Top = 117
        Width = 74
        Height = 13
        Caption = 'Sens de lecture'
        ShowAccelChar = False
      end
      object Label22: TLabel
        Left = 4
        Top = 181
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'N'#176' perso :'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbNumeroPerso: TLabel
        Left = 56
        Top = 181
        Width = 87
        Height = 13
        Caption = 'Numero personnel'
        ShowAccelChar = False
      end
      object cbVO: TReadOnlyCheckBox
        Left = 213
        Top = 17
        Width = 33
        Height = 16
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'VO'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 2
      end
      object ListeEmprunts: TVirtualStringTree
        Left = 8
        Top = 224
        Width = 505
        Height = 116
        Anchors = [akLeft, akTop, akRight]
        AnimationDuration = 0
        BevelInner = bvLowered
        BevelOuter = bvNone
        BevelKind = bkFlat
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
        Header.AutoSizeIndex = 1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Images = frmFond.ImageList1
        Header.MainColumn = 1
        Header.Options = [hoAutoResize, hoColumnResize, hoShowImages, hoVisible]
        Header.Style = hsPlates
        HotCursor = crHandPoint
        Images = frmFond.ImageList1
        TabOrder = 7
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
        OnDblClick = ListeEmpruntsDblClick
        OnGetText = ListeEmpruntsGetText
        OnGetImageIndex = ListeEmpruntsGetImageIndex
        OnHeaderClick = ListeEmpruntsHeaderClick
        Columns = <
          item
            Position = 0
            Width = 100
            WideText = 'Date'
          end
          item
            Position = 1
            Width = 403
            WideText = 'Emprunteur'
          end>
      end
      object ajouter: TButton
        Left = 441
        Top = 202
        Width = 72
        Height = 20
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = 'Ajouter'
        Enabled = False
        TabOrder = 6
        OnClick = ajouterClick
      end
      object cbCouleur: TReadOnlyCheckBox
        Left = 262
        Top = 34
        Width = 56
        Height = 15
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Couleur'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 4
      end
      object cbStock: TReadOnlyCheckBox
        Left = 273
        Top = 1
        Width = 45
        Height = 15
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Stock'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 1
      end
      object edNotes: TMemo
        Left = 56
        Top = 134
        Width = 457
        Height = 40
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvLowered
        BevelKind = bkFlat
        BevelOuter = bvNone
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object cbOffert: TReadOnlyCheckBox
        Left = 197
        Top = 0
        Width = 49
        Height = 16
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Offert'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 0
      end
      object cbDedicace: TReadOnlyCheckBox
        Left = 183
        Top = 33
        Width = 63
        Height = 16
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'D'#233'dicac'#233
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        State = cbGrayed
        TabOrder = 3
      end
    end
    object lvEditions: TListBox
      Left = 346
      Top = 467
      Width = 170
      Height = 62
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clWhite
      ItemHeight = 13
      TabOrder = 10
      OnClick = lvEditionsClick
    end
  end
  object Popup3: TPopupMenu
    Left = 304
    Top = 16
    object Informations1: TMenuItem
      Caption = '&Informations'
      object Emprunts1: TMenuItem
        Caption = 'Emprunts :'
      end
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object Adresse1: TMenuItem
      Caption = '&Adresse'
    end
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 420
    Top = 14
    object EmpruntApercu: TAction
      Tag = 1
      Category = 'Emprunts'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Imprimer1Click
    end
    object FicheApercu: TAction
      Tag = 1
      Category = 'Fiche'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Impression1Click
    end
    object CouvertureApercu: TAction
      Tag = 1
      Category = 'Couverture'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = Imprimer2Click
    end
    object FicheImprime: TAction
      Tag = 2
      Category = 'Fiche'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Impression1Click
    end
    object EmpruntImprime: TAction
      Tag = 2
      Category = 'Emprunts'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Imprimer1Click
    end
    object CouvertureImprime: TAction
      Tag = 2
      Category = 'Couverture'
      Caption = 'Imprimer'
      ImageIndex = 3
      OnExecute = Imprimer2Click
    end
  end
  object MainMenu1: TMainMenu
    AutoMerge = True
    Images = frmFond.boutons_32x32_hot
    Left = 336
    Top = 16
    object Fiche1: TMenuItem
      Caption = 'Fiche'
      GroupIndex = 1
      object Aperuavantimpression1: TMenuItem
        Action = FicheApercu
      end
      object Aperuavantimpression2: TMenuItem
        Action = FicheImprime
      end
    end
    object Couverture1: TMenuItem
      Caption = 'Image'
      GroupIndex = 1
      object Aperuavantimpression5: TMenuItem
        Action = CouvertureApercu
      end
      object Aperuavantimpression6: TMenuItem
        Action = CouvertureImprime
      end
    end
    object Emprunts2: TMenuItem
      Caption = 'Emprunts'
      GroupIndex = 1
      object Aperuavantimpression3: TMenuItem
        Action = EmpruntApercu
      end
      object Aperuavantimpression4: TMenuItem
        Action = EmpruntImprime
      end
    end
  end
end
