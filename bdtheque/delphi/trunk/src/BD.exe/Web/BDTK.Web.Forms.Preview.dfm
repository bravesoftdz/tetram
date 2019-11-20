object frmBDTKWebPreview: TfrmBDTKWebPreview
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Donn'#233'es r'#233'cup'#233'r'#233'es'
  ClientHeight = 545
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 520
    Height = 545
    ActivePage = TabEdition
    Style = tsFlatButtons
    TabOrder = 0
    object TabAlbum: TTabSheet
      Caption = 'Album'
      object Label17: TLabel
        Left = 428
        Top = 143
        Width = 6
        Height = 13
        Alignment = taRightJustify
        Caption = #224
        FocusControl = edTomeFin
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object edTitreAlbum: TEditLabeled
        Left = 144
        Top = 8
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 0
        LinkControls = <
          item
            Control = CheckBox1
          end>
        CurrencyChar = #0
      end
      object CheckBox1: TCheckBoxLabeled
        Left = 8
        Top = 10
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Titre'
        TabOrder = 1
        LinkControls = <
          item
            Control = CheckBox1
          end>
      end
      object edTome: TEditLabeled
        Left = 144
        Top = 35
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 3
        TabOrder = 2
        LinkControls = <
          item
            Control = CheckBox2
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object CheckBox2: TCheckBoxLabeled
        Left = 8
        Top = 37
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Tome'
        TabOrder = 3
        LinkControls = <
          item
            Control = CheckBox2
          end>
      end
      object edMoisParution: TEditLabeled
        Left = 144
        Top = 62
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 2
        TabOrder = 4
        LinkControls = <
          item
            Control = CheckBox3
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object CheckBox3: TCheckBoxLabeled
        Left = 8
        Top = 64
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Mois de parution'
        TabOrder = 5
        LinkControls = <
          item
            Control = CheckBox3
          end>
      end
      object edAnneeParution: TEditLabeled
        Left = 144
        Top = 89
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 4
        TabOrder = 6
        LinkControls = <
          item
            Control = CheckBox4
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object CheckBox4: TCheckBoxLabeled
        Left = 8
        Top = 91
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Ann'#233'e de parution'
        TabOrder = 7
        LinkControls = <
          item
            Control = CheckBox4
          end>
      end
      object pnHorsSerie: TPanel
        Left = 144
        Top = 115
        Width = 361
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 8
        object RadioButton1: TRadioButtonLabeled
          Left = 3
          Top = 2
          Width = 41
          Height = 17
          Caption = 'Oui'
          TabOrder = 0
          LinkControls = <
            item
              Control = CheckBox5
            end>
        end
        object RadioButton2: TRadioButtonLabeled
          Left = 50
          Top = 2
          Width = 48
          Height = 17
          Caption = 'Non'
          Checked = True
          TabOrder = 1
          TabStop = True
          LinkControls = <
            item
              Control = CheckBox5
            end>
        end
      end
      object CheckBox5: TCheckBoxLabeled
        Left = 8
        Top = 117
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Hors s'#233'rie'
        TabOrder = 9
        LinkControls = <
          item
            Control = CheckBox5
          end>
      end
      object pnIntegrale: TPanel
        Left = 144
        Top = 140
        Width = 98
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 10
        object RadioButton3: TRadioButtonLabeled
          Left = 3
          Top = 1
          Width = 41
          Height = 17
          Caption = 'Oui'
          TabOrder = 0
          LinkControls = <
            item
              Control = CheckBox6
            end>
        end
        object RadioButton4: TRadioButtonLabeled
          Left = 50
          Top = 1
          Width = 48
          Height = 17
          Caption = 'Non'
          Checked = True
          TabOrder = 1
          TabStop = True
          LinkControls = <
            item
              Control = CheckBox6
            end>
        end
      end
      object CheckBox6: TCheckBoxLabeled
        Left = 8
        Top = 142
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Int'#233'grale'
        TabOrder = 11
        LinkControls = <
          item
            Control = CheckBox6
          end>
      end
      object edTomeDebut: TEditLabeled
        Left = 383
        Top = 140
        Width = 39
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 3
        TabOrder = 12
        LinkControls = <
          item
            Control = CheckBox7
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object edTomeFin: TEditLabeled
        Left = 440
        Top = 140
        Width = 39
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 3
        TabOrder = 13
        LinkControls = <
          item
            Control = CheckBox7
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object CheckBox7: TCheckBoxLabeled
        Left = 322
        Top = 143
        Width = 55
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Tomes'
        TabOrder = 14
        LinkControls = <
          item
            Control = CheckBox7
          end>
      end
      object cklScenaristes: TCheckListBoxLabeled
        Left = 144
        Top = 166
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 15
        LinkControls = <
          item
            Control = CheckBox8
          end>
      end
      object CheckBox8: TCheckBoxLabeled
        Left = 8
        Top = 168
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Sc'#233'naristes'
        TabOrder = 16
        LinkControls = <
          item
            Control = CheckBox8
          end>
      end
      object cklDessinateurs: TCheckListBoxLabeled
        Left = 144
        Top = 206
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 17
        LinkControls = <
          item
            Control = CheckBox9
          end>
      end
      object CheckBox9: TCheckBoxLabeled
        Left = 8
        Top = 207
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Dessinateurs'
        TabOrder = 18
        LinkControls = <
          item
            Control = CheckBox9
          end>
      end
      object cklColoristes: TCheckListBoxLabeled
        Left = 144
        Top = 246
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 19
        LinkControls = <
          item
            Control = CheckBox10
          end>
      end
      object CheckBox10: TCheckBoxLabeled
        Left = 8
        Top = 248
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Coloristes'
        TabOrder = 20
        LinkControls = <
          item
            Control = CheckBox10
          end>
      end
      object mmResumeAlbum: TMemoLabeled
        Left = 144
        Top = 286
        Width = 361
        Height = 57
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        ScrollBars = ssVertical
        TabOrder = 21
        LinkControls = <
          item
            Control = CheckBox11
          end>
      end
      object CheckBox11: TCheckBoxLabeled
        Left = 8
        Top = 288
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'R'#233'sum'#233
        TabOrder = 22
        LinkControls = <
          item
            Control = CheckBox11
          end>
      end
      object mmNotesAlbum: TMemoLabeled
        Left = 144
        Top = 349
        Width = 361
        Height = 57
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        ScrollBars = ssVertical
        TabOrder = 23
        LinkControls = <
          item
            Control = CheckBox12
          end>
      end
      object CheckBox12: TCheckBoxLabeled
        Left = 8
        Top = 351
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Notes'
        TabOrder = 24
        LinkControls = <
          item
            Control = CheckBox12
          end>
      end
    end
    object TabSerie: TTabSheet
      Caption = 'S'#233'rie'
      ImageIndex = 1
      object edTitreSerie: TEditLabeled
        Left = 144
        Top = 8
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 0
        LinkControls = <
          item
            Control = CheckBox13
          end>
        CurrencyChar = #0
      end
      object CheckBox13: TCheckBoxLabeled
        Left = 8
        Top = 10
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Titre'
        TabOrder = 1
        LinkControls = <
          item
            Control = CheckBox13
          end>
      end
      object edSiteWebSerie: TEditLabeled
        Left = 144
        Top = 35
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 3
        TabOrder = 2
        LinkControls = <
          item
            Control = CheckBox16
          end>
        CurrencyChar = #0
      end
      object CheckBox16: TCheckBoxLabeled
        Left = 8
        Top = 37
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Site web'
        TabOrder = 3
        LinkControls = <
          item
            Control = CheckBox16
          end>
      end
      object edNbAlbums: TEditLabeled
        Left = 144
        Top = 102
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 3
        TabOrder = 6
        LinkControls = <
          item
            Control = CheckBox19
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object pnTerminee: TPanel
        Left = 144
        Top = 127
        Width = 361
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 8
        object RadioButton5: TRadioButtonLabeled
          Left = 3
          Top = 2
          Width = 41
          Height = 17
          Caption = 'Oui'
          TabOrder = 0
          LinkControls = <
            item
              Control = CheckBox14
            end>
        end
        object RadioButton6: TRadioButtonLabeled
          Left = 50
          Top = 2
          Width = 41
          Height = 17
          Caption = 'Non'
          TabOrder = 1
          LinkControls = <
            item
              Control = CheckBox14
            end>
        end
        object RadioButtonLabeled1: TRadioButtonLabeled
          Left = 97
          Top = 2
          Width = 41
          Height = 17
          Caption = '?'
          Checked = True
          TabOrder = 2
          TabStop = True
          LinkControls = <
            item
              Control = CheckBox14
            end>
        end
      end
      object CheckBox14: TCheckBoxLabeled
        Left = 8
        Top = 129
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Termin'#233'e'
        TabOrder = 9
        LinkControls = <
          item
            Control = CheckBox14
          end>
      end
      object cklGenres: TCheckListBoxLabeled
        Left = 144
        Top = 153
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 10
        LinkControls = <
          item
            Control = CheckBox15
          end>
      end
      object CheckBox15: TCheckBoxLabeled
        Left = 8
        Top = 155
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Genres'
        TabOrder = 11
        LinkControls = <
          item
            Control = CheckBox15
          end>
      end
      object mmResumeSerie: TMemoLabeled
        Left = 144
        Top = 394
        Width = 361
        Height = 57
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        ScrollBars = ssVertical
        TabOrder = 24
        LinkControls = <
          item
            Control = CheckBox17
          end>
      end
      object CheckBox17: TCheckBoxLabeled
        Left = 8
        Top = 396
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'R'#233'sum'#233
        TabOrder = 25
        LinkControls = <
          item
            Control = CheckBox17
          end>
      end
      object mmNotesSerie: TMemoLabeled
        Left = 144
        Top = 457
        Width = 361
        Height = 57
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        ScrollBars = ssVertical
        TabOrder = 26
        LinkControls = <
          item
            Control = CheckBox18
          end>
      end
      object CheckBox18: TCheckBoxLabeled
        Left = 8
        Top = 459
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Notes'
        TabOrder = 27
        LinkControls = <
          item
            Control = CheckBox18
          end>
      end
      object cklScenaristesSerie: TCheckListBoxLabeled
        Left = 144
        Top = 274
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 18
        LinkControls = <
          item
            Control = CheckBoxLabeled2
          end>
      end
      object CheckBoxLabeled2: TCheckBoxLabeled
        Left = 8
        Top = 276
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Sc'#233'naristes'
        TabOrder = 19
        LinkControls = <
          item
            Control = CheckBoxLabeled2
          end>
      end
      object cklDessinateursSerie: TCheckListBoxLabeled
        Left = 144
        Top = 314
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 20
        LinkControls = <
          item
            Control = CheckBoxLabeled3
          end>
      end
      object CheckBoxLabeled3: TCheckBoxLabeled
        Left = 8
        Top = 315
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Dessinateurs'
        TabOrder = 21
        LinkControls = <
          item
            Control = CheckBoxLabeled3
          end>
      end
      object cklColoristesSerie: TCheckListBoxLabeled
        Left = 144
        Top = 354
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 22
        LinkControls = <
          item
            Control = CheckBoxLabeled4
          end>
      end
      object CheckBoxLabeled4: TCheckBoxLabeled
        Left = 8
        Top = 356
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Coloristes'
        TabOrder = 23
        LinkControls = <
          item
            Control = CheckBoxLabeled4
          end>
      end
      object CheckBoxLabeled5: TCheckBoxLabeled
        Left = 10
        Top = 195
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Editeur'
        TabOrder = 13
        LinkControls = <
          item
            Control = CheckBoxLabeled5
          end>
      end
      object edNomEditeurSerie: TEditLabeled
        Left = 144
        Top = 193
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 12
        LinkControls = <
          item
            Control = CheckBoxLabeled5
          end>
        CurrencyChar = #0
      end
      object edSiteWebEditeurSerie: TEditLabeled
        Left = 232
        Top = 219
        Width = 273
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 14
        LinkControls = <
          item
            Control = CheckBoxLabeled6
          end>
        CurrencyChar = #0
      end
      object CheckBoxLabeled6: TCheckBoxLabeled
        Left = 144
        Top = 221
        Width = 82
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Site web'
        TabOrder = 15
        LinkControls = <
          item
            Control = CheckBoxLabeled6
          end>
      end
      object edCollectionSerie: TEditLabeled
        Left = 144
        Top = 247
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 16
        LinkControls = <
          item
            Control = CheckBoxLabeled7
          end>
        CurrencyChar = #0
      end
      object CheckBoxLabeled7: TCheckBoxLabeled
        Left = 8
        Top = 249
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Collection'
        TabOrder = 17
        LinkControls = <
          item
            Control = CheckBoxLabeled7
          end>
      end
      object cklUnivers: TCheckListBoxLabeled
        Left = 144
        Top = 62
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 4
        LinkControls = <
          item
          end>
      end
      object CheckBox19: TCheckBoxLabeled
        Left = 8
        Top = 64
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Univers'
        TabOrder = 5
        LinkControls = <
          item
            Control = CheckBox19
          end>
      end
      object CheckBoxLabeled8: TCheckBoxLabeled
        Left = 8
        Top = 104
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Nombre d'#39'albums'
        TabOrder = 7
        LinkControls = <
          item
            Control = CheckBoxLabeled8
          end>
      end
    end
    object TabEdition: TTabSheet
      Caption = 'Edition'
      ImageIndex = 2
      object cbxEtat: TLightComboCheck
        Left = 144
        Top = 169
        Width = 361
        Height = 13
        Checked = False
        Enabled = False
        PropertiesStored = False
        Transparent = False
        CheckVisible = False
        TextClick = False
        BeforeShowPop = cbxEtatBeforeShowPop
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object cbxEdition: TLightComboCheck
        Left = 144
        Top = 188
        Width = 361
        Height = 13
        Checked = False
        Enabled = False
        PropertiesStored = False
        Transparent = False
        CheckVisible = False
        TextClick = False
        BeforeShowPop = cbxEtatBeforeShowPop
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object cbxReliure: TLightComboCheck
        Left = 144
        Top = 207
        Width = 361
        Height = 13
        Checked = False
        Enabled = False
        PropertiesStored = False
        Transparent = False
        CheckVisible = False
        TextClick = False
        BeforeShowPop = cbxEtatBeforeShowPop
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object cbxOrientation: TLightComboCheck
        Left = 144
        Top = 226
        Width = 361
        Height = 13
        Checked = False
        Enabled = False
        PropertiesStored = False
        Transparent = False
        CheckVisible = False
        TextClick = False
        BeforeShowPop = cbxEtatBeforeShowPop
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object cbxSensLecture: TLightComboCheck
        Left = 144
        Top = 245
        Width = 361
        Height = 13
        Checked = False
        Enabled = False
        PropertiesStored = False
        Transparent = False
        CheckVisible = False
        TextClick = False
        BeforeShowPop = cbxEtatBeforeShowPop
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object cbxFormat: TLightComboCheck
        Left = 144
        Top = 264
        Width = 361
        Height = 13
        Checked = False
        Enabled = False
        PropertiesStored = False
        Transparent = False
        CheckVisible = False
        TextClick = False
        BeforeShowPop = cbxEtatBeforeShowPop
        ShowCaptionHint = False
        AssignHint = False
        OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
        Items.CaptionComplet = True
        Items.Separateur = ' '
        Items = <>
      end
      object imgVisu: TImage
        Left = 408
        Top = 411
        Width = 97
        Height = 102
        Cursor = crHandPoint
        Center = True
        OnClick = imgVisuClick
      end
      object edNomEditeur: TEditLabeled
        Left = 144
        Top = 8
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 0
        LinkControls = <
          item
            Control = CheckBox20
          end>
        CurrencyChar = #0
      end
      object CheckBox20: TCheckBoxLabeled
        Left = 8
        Top = 10
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Editeur'
        TabOrder = 1
        LinkControls = <
          item
            Control = CheckBox20
          end>
      end
      object edSiteWebEditeur: TEditLabeled
        Left = 232
        Top = 35
        Width = 273
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 2
        LinkControls = <
          item
            Control = CheckBox21
          end>
        CurrencyChar = #0
      end
      object CheckBox21: TCheckBoxLabeled
        Left = 144
        Top = 37
        Width = 82
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Site web'
        TabOrder = 3
        LinkControls = <
          item
            Control = CheckBox21
          end>
      end
      object edCollection: TEditLabeled
        Left = 144
        Top = 62
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 4
        LinkControls = <
          item
            Control = CheckBox22
          end>
        CurrencyChar = #0
      end
      object CheckBox22: TCheckBoxLabeled
        Left = 8
        Top = 64
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Collection'
        TabOrder = 5
        LinkControls = <
          item
            Control = CheckBox22
          end>
      end
      object edAnneeEdition: TEditLabeled
        Left = 144
        Top = 89
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 6
        LinkControls = <
          item
            Control = CheckBox29
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object CheckBox29: TCheckBoxLabeled
        Left = 8
        Top = 91
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Ann'#233'e d'#39#233'dition'
        TabOrder = 7
        LinkControls = <
          item
            Control = CheckBox29
          end>
      end
      object edPrix: TEditLabeled
        Left = 144
        Top = 116
        Width = 175
        Height = 21
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        Ctl3D = True
        Enabled = False
        ParentCtl3D = False
        TabOrder = 8
        LinkControls = <
          item
            Control = Label9
          end
          item
          end>
        TypeDonnee = tdCurrency
        CurrencyChar = #0
      end
      object Label9: TCheckBoxLabeled
        Left = 8
        Top = 118
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Prix'
        TabOrder = 9
        LinkControls = <
          item
            Control = Label9
          end>
      end
      object pnGratuit: TPanel
        Left = 408
        Top = 116
        Width = 97
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 10
        object RadioButton7: TRadioButtonLabeled
          Left = 3
          Top = 2
          Width = 41
          Height = 17
          Caption = 'Oui'
          TabOrder = 0
          LinkControls = <
            item
              Control = CheckBox30
            end>
        end
        object RadioButton8: TRadioButtonLabeled
          Left = 50
          Top = 2
          Width = 48
          Height = 17
          Caption = 'Non'
          Checked = True
          TabOrder = 1
          TabStop = True
          LinkControls = <
            item
              Control = CheckBox30
            end>
        end
      end
      object CheckBox30: TCheckBoxLabeled
        Left = 325
        Top = 118
        Width = 77
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Gratuit'
        TabOrder = 11
        LinkControls = <
          item
            Control = CheckBox30
          end>
      end
      object edISBN: TEditLabeled
        Left = 144
        Top = 143
        Width = 361
        Height = 21
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        CharCase = ecUpperCase
        Ctl3D = True
        Enabled = False
        MaxLength = 13
        ParentCtl3D = False
        TabOrder = 12
        LinkControls = <
          item
            Control = Label11
          end>
        TypeDonnee = tdISBN
        CurrencyChar = #0
      end
      object Label11: TCheckBoxLabeled
        Left = 8
        Top = 145
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'ISBN'
        TabOrder = 13
        LinkControls = <
          item
            Control = Label11
          end>
      end
      object CheckBox23: TCheckBoxLabeled
        Left = 8
        Top = 168
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Etat'
        TabOrder = 14
        LinkControls = <
          item
            Control = CheckBox23
          end>
      end
      object CheckBox24: TCheckBoxLabeled
        Left = 8
        Top = 187
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Type d'#39#233'dition'
        TabOrder = 15
        LinkControls = <
          item
            Control = CheckBox24
          end>
      end
      object CheckBox25: TCheckBoxLabeled
        Left = 8
        Top = 206
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Reliure'
        TabOrder = 16
        LinkControls = <
          item
            Control = CheckBox25
          end>
      end
      object CheckBox26: TCheckBoxLabeled
        Left = 8
        Top = 225
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Orientation'
        TabOrder = 17
        LinkControls = <
          item
            Control = CheckBox26
          end>
      end
      object CheckBox27: TCheckBoxLabeled
        Left = 8
        Top = 244
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Sens de lecture'
        TabOrder = 18
        LinkControls = <
          item
            Control = CheckBox27
          end>
      end
      object CheckBox28: TCheckBoxLabeled
        Left = 8
        Top = 263
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Format'
        TabOrder = 19
        LinkControls = <
          item
            Control = CheckBox28
          end>
      end
      object pnCouleur: TPanel
        Left = 144
        Top = 283
        Width = 361
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 20
        object RadioButton9: TRadioButtonLabeled
          Left = 3
          Top = 2
          Width = 41
          Height = 17
          Caption = 'Oui'
          Checked = True
          TabOrder = 0
          TabStop = True
          LinkControls = <
            item
              Control = CheckBox31
            end>
        end
        object RadioButton10: TRadioButtonLabeled
          Left = 50
          Top = 2
          Width = 48
          Height = 17
          Caption = 'Non'
          TabOrder = 1
          LinkControls = <
            item
              Control = CheckBox31
            end>
        end
      end
      object CheckBox31: TCheckBoxLabeled
        Left = 8
        Top = 285
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Couleur'
        TabOrder = 21
        LinkControls = <
          item
            Control = CheckBox31
          end>
      end
      object pnVO: TPanel
        Left = 144
        Top = 305
        Width = 361
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 22
        object RadioButton11: TRadioButtonLabeled
          Left = 3
          Top = 2
          Width = 41
          Height = 17
          Caption = 'Oui'
          TabOrder = 0
          LinkControls = <
            item
            end>
        end
        object RadioButton12: TRadioButtonLabeled
          Left = 50
          Top = 2
          Width = 48
          Height = 17
          Caption = 'Non'
          Checked = True
          TabOrder = 1
          TabStop = True
          LinkControls = <
            item
            end>
        end
      end
      object edNbPages: TEditLabeled
        Left = 144
        Top = 330
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 4
        TabOrder = 24
        LinkControls = <
          item
            Control = CheckBox33
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object CheckBox33: TCheckBoxLabeled
        Left = 8
        Top = 332
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Nombre de pages'
        TabOrder = 25
        LinkControls = <
          item
            Control = CheckBox33
          end>
      end
      object edAnneeCote: TEditLabeled
        Left = 144
        Top = 357
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 4
        TabOrder = 26
        LinkControls = <
          item
            Control = Label24
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object Label24: TCheckBoxLabeled
        Left = 8
        Top = 359
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Ann'#233'e de la cotation'
        TabOrder = 27
        LinkControls = <
          item
            Control = Label24
          end>
      end
      object edPrixCote: TEditLabeled
        Left = 144
        Top = 384
        Width = 361
        Height = 21
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        Ctl3D = True
        Enabled = False
        ParentCtl3D = False
        TabOrder = 28
        LinkControls = <
          item
            Control = Label25
          end
          item
          end>
        TypeDonnee = tdCurrency
        CurrencyChar = #0
      end
      object Label25: TCheckBoxLabeled
        Left = 8
        Top = 386
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Cote'
        TabOrder = 29
        LinkControls = <
          item
            Control = Label25
          end>
      end
      object cklImages: TCheckListBoxLabeled
        Left = 144
        Top = 411
        Width = 258
        Height = 102
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 30
        OnClick = cklImagesClick
        LinkControls = <
          item
            Control = CheckBoxLabeled1
          end>
      end
      object CheckBoxLabeled1: TCheckBoxLabeled
        Left = 8
        Top = 413
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Images'
        TabOrder = 31
        LinkControls = <
          item
            Control = CheckBoxLabeled1
          end>
      end
      object CheckBox32: TCheckBoxLabeled
        Left = 8
        Top = 307
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'VO'
        TabOrder = 23
        LinkControls = <
          item
            Control = CheckBox32
          end>
      end
    end
  end
end
