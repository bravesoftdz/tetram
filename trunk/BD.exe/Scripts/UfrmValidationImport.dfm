object frmValidationImport: TfrmValidationImport
  Left = 0
  Top = 0
  ActiveControl = framBoutons1.btnOK
  Caption = 'frmValidationImport'
  ClientHeight = 535
  ClientWidth = 526
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
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 508
    Width = 526
    Height = 27
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 508
    ExplicitWidth = 526
    ExplicitHeight = 27
    inherited btnOK: TButton
      Left = 363
      Top = 4
      OnClick = framBoutons1btnOKClick
      ExplicitLeft = 363
      ExplicitTop = 4
    end
    inherited btnAnnuler: TButton
      Left = 443
      Top = 4
      ExplicitLeft = 443
      ExplicitTop = 4
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 520
    Height = 505
    ActivePage = TabSheet2
    Style = tsFlatButtons
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Album'
      object Label17: TLabel
        Left = 428
        Top = 128
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
        ReadOnly = True
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
        Top = 32
        Width = 361
        Height = 22
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 3
        ReadOnly = True
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
        Top = 34
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
        Top = 57
        Width = 361
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 2
        ReadOnly = True
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
        Top = 59
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
        Top = 80
        Width = 361
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        ReadOnly = True
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
        Top = 82
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
        Top = 103
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
        Top = 105
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
        Top = 125
        Width = 98
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 10
        object RadioButton3: TRadioButtonLabeled
          Left = 3
          Top = 2
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
          Top = 2
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
        Top = 127
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
        Top = 125
        Width = 39
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 3
        ReadOnly = True
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
        Top = 125
        Width = 39
        Height = 20
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 3
        ReadOnly = True
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
        Top = 127
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
        Top = 148
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
        Top = 150
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
        Top = 185
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
        Top = 186
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
        Top = 222
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
        Top = 224
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
        Top = 259
        Width = 361
        Height = 57
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 21
        LinkControls = <
          item
            Control = CheckBox11
          end>
      end
      object CheckBox11: TCheckBoxLabeled
        Left = 8
        Top = 261
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
        Top = 319
        Width = 361
        Height = 57
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 23
        LinkControls = <
          item
            Control = CheckBox12
          end>
      end
      object CheckBox12: TCheckBoxLabeled
        Left = 8
        Top = 321
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
    object TabSheet2: TTabSheet
      Caption = 'S'#233'rie'
      ImageIndex = 1
      object edTitreSerie: TEditLabeled
        Left = 144
        Top = 8
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
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
        Top = 32
        Width = 361
        Height = 22
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 3
        ReadOnly = True
        TabOrder = 2
        LinkControls = <
          item
            Control = CheckBox16
          end>
        CurrencyChar = #0
      end
      object CheckBox16: TCheckBoxLabeled
        Left = 8
        Top = 34
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
        Top = 57
        Width = 361
        Height = 22
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 3
        ReadOnly = True
        TabOrder = 4
        LinkControls = <
          item
            Control = CheckBox19
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object CheckBox19: TCheckBoxLabeled
        Left = 8
        Top = 59
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Nombre d'#39'albums'
        TabOrder = 5
        LinkControls = <
          item
            Control = CheckBox19
          end>
      end
      object pnTerminee: TPanel
        Left = 144
        Top = 82
        Width = 361
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 6
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
        Top = 84
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Termin'#233'e'
        TabOrder = 7
        LinkControls = <
          item
            Control = CheckBox14
          end>
      end
      object cklGenres: TCheckListBoxLabeled
        Left = 144
        Top = 105
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 8
        LinkControls = <
          item
            Control = CheckBox15
          end>
      end
      object CheckBox15: TCheckBoxLabeled
        Left = 8
        Top = 107
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Genres'
        TabOrder = 9
        LinkControls = <
          item
            Control = CheckBox15
          end>
      end
      object mmResumeSerie: TMemoLabeled
        Left = 144
        Top = 325
        Width = 361
        Height = 57
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 22
        LinkControls = <
          item
            Control = CheckBox17
          end>
      end
      object CheckBox17: TCheckBoxLabeled
        Left = 8
        Top = 327
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'R'#233'sum'#233
        TabOrder = 23
        LinkControls = <
          item
            Control = CheckBox17
          end>
      end
      object mmNotesSerie: TMemoLabeled
        Left = 144
        Top = 385
        Width = 361
        Height = 57
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 24
        LinkControls = <
          item
            Control = CheckBox18
          end>
      end
      object CheckBox18: TCheckBoxLabeled
        Left = 8
        Top = 387
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Notes'
        TabOrder = 25
        LinkControls = <
          item
            Control = CheckBox18
          end>
      end
      object cklScenaristesSerie: TCheckListBoxLabeled
        Left = 144
        Top = 214
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 16
        LinkControls = <
          item
            Control = CheckBoxLabeled2
          end>
      end
      object CheckBoxLabeled2: TCheckBoxLabeled
        Left = 8
        Top = 216
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Sc'#233'naristes'
        TabOrder = 17
        LinkControls = <
          item
            Control = CheckBoxLabeled2
          end>
      end
      object cklDessinateursSerie: TCheckListBoxLabeled
        Left = 144
        Top = 251
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 18
        LinkControls = <
          item
            Control = CheckBoxLabeled3
          end>
      end
      object CheckBoxLabeled3: TCheckBoxLabeled
        Left = 8
        Top = 252
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Dessinateurs'
        TabOrder = 19
        LinkControls = <
          item
            Control = CheckBoxLabeled3
          end>
      end
      object cklColoristesSerie: TCheckListBoxLabeled
        Left = 144
        Top = 288
        Width = 361
        Height = 34
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 20
        LinkControls = <
          item
            Control = CheckBoxLabeled4
          end>
      end
      object CheckBoxLabeled4: TCheckBoxLabeled
        Left = 8
        Top = 290
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Coloristes'
        TabOrder = 21
        LinkControls = <
          item
            Control = CheckBoxLabeled4
          end>
      end
      object CheckBoxLabeled5: TCheckBoxLabeled
        Left = 10
        Top = 144
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Editeur'
        TabOrder = 11
        LinkControls = <
          item
            Control = CheckBoxLabeled5
          end>
      end
      object edNomEditeurSerie: TEditLabeled
        Left = 144
        Top = 142
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 10
        LinkControls = <
          item
            Control = CheckBoxLabeled5
          end>
        CurrencyChar = #0
      end
      object edSiteWebEditeurSerie: TEditLabeled
        Left = 232
        Top = 166
        Width = 273
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 12
        LinkControls = <
          item
            Control = CheckBoxLabeled6
          end>
        CurrencyChar = #0
      end
      object CheckBoxLabeled6: TCheckBoxLabeled
        Left = 144
        Top = 167
        Width = 82
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Site web'
        TabOrder = 13
        LinkControls = <
          item
            Control = CheckBoxLabeled6
          end>
      end
      object edCollectionSerie: TEditLabeled
        Left = 144
        Top = 190
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 14
        LinkControls = <
          item
            Control = CheckBoxLabeled7
          end>
        CurrencyChar = #0
      end
      object CheckBoxLabeled7: TCheckBoxLabeled
        Left = 8
        Top = 192
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Collection'
        TabOrder = 15
        LinkControls = <
          item
            Control = CheckBoxLabeled7
          end>
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Edition'
      ImageIndex = 2
      object cbxEtat: TLightComboCheck
        Left = 144
        Top = 151
        Width = 361
        Height = 13
        Checked = False
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
        Top = 168
        Width = 361
        Height = 13
        Checked = False
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
        Top = 185
        Width = 361
        Height = 13
        Checked = False
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
        Top = 201
        Width = 361
        Height = 13
        Checked = False
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
        Top = 219
        Width = 361
        Height = 13
        Checked = False
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
        Top = 236
        Width = 361
        Height = 13
        Checked = False
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
        Top = 368
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
        ReadOnly = True
        TabOrder = 15
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
        TabOrder = 16
        LinkControls = <
          item
            Control = CheckBox20
          end>
      end
      object edSiteWebEditeur: TEditLabeled
        Left = 232
        Top = 32
        Width = 273
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 17
        LinkControls = <
          item
            Control = CheckBox21
          end>
        CurrencyChar = #0
      end
      object CheckBox21: TCheckBoxLabeled
        Left = 144
        Top = 33
        Width = 82
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Site web'
        TabOrder = 18
        LinkControls = <
          item
            Control = CheckBox21
          end>
      end
      object edCollection: TEditLabeled
        Left = 144
        Top = 56
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 19
        LinkControls = <
          item
            Control = CheckBox22
          end>
        CurrencyChar = #0
      end
      object CheckBox22: TCheckBoxLabeled
        Left = 8
        Top = 58
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Collection'
        TabOrder = 20
        LinkControls = <
          item
            Control = CheckBox22
          end>
      end
      object edAnneeEdition: TEditLabeled
        Left = 144
        Top = 80
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 21
        LinkControls = <
          item
            Control = CheckBox29
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object CheckBox29: TCheckBoxLabeled
        Left = 8
        Top = 82
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Ann'#233'e d'#39#233'dition'
        TabOrder = 22
        LinkControls = <
          item
            Control = CheckBox29
          end>
      end
      object edPrix: TEditLabeled
        Left = 144
        Top = 104
        Width = 175
        Height = 21
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 0
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
        Top = 105
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Prix'
        TabOrder = 1
        LinkControls = <
          item
            Control = Label9
          end>
      end
      object pnGratuit: TPanel
        Left = 408
        Top = 104
        Width = 97
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 24
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
        Top = 106
        Width = 77
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Gratuit'
        TabOrder = 25
        LinkControls = <
          item
            Control = CheckBox30
          end>
      end
      object edISBN: TEditLabeled
        Left = 144
        Top = 128
        Width = 361
        Height = 20
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        CharCase = ecUpperCase
        Ctl3D = True
        MaxLength = 13
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 26
        LinkControls = <
          item
            Control = Label11
          end>
        TypeDonnee = tdISBN
        CurrencyChar = #0
      end
      object Label11: TCheckBoxLabeled
        Left = 8
        Top = 128
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'ISBN'
        TabOrder = 27
        LinkControls = <
          item
            Control = Label11
          end>
      end
      object CheckBox23: TCheckBoxLabeled
        Left = 8
        Top = 150
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Etat'
        TabOrder = 28
        LinkControls = <
          item
            Control = CheckBox23
          end>
      end
      object CheckBox24: TCheckBoxLabeled
        Left = 8
        Top = 167
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Type d'#39#233'dition'
        TabOrder = 29
        LinkControls = <
          item
            Control = CheckBox24
          end>
      end
      object CheckBox25: TCheckBoxLabeled
        Left = 8
        Top = 184
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Reliure'
        TabOrder = 30
        LinkControls = <
          item
            Control = CheckBox25
          end>
      end
      object CheckBox26: TCheckBoxLabeled
        Left = 8
        Top = 200
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Orientation'
        TabOrder = 31
        LinkControls = <
          item
            Control = CheckBox26
          end>
      end
      object CheckBox27: TCheckBoxLabeled
        Left = 8
        Top = 216
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Sens de lecture'
        TabOrder = 10
        LinkControls = <
          item
            Control = CheckBox27
          end>
      end
      object CheckBox28: TCheckBoxLabeled
        Left = 8
        Top = 232
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Format'
        TabOrder = 11
        LinkControls = <
          item
            Control = CheckBox28
          end>
      end
      object pnCouleur: TPanel
        Left = 144
        Top = 255
        Width = 361
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 12
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
        Top = 254
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Couleur'
        TabOrder = 13
        LinkControls = <
          item
            Control = CheckBox31
          end>
      end
      object pnVO: TPanel
        Left = 144
        Top = 274
        Width = 361
        Height = 20
        BevelOuter = bvNone
        Caption = ' '
        Enabled = False
        TabOrder = 14
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
        Top = 296
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        ReadOnly = True
        TabOrder = 2
        LinkControls = <
          item
            Control = CheckBox33
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object CheckBox33: TCheckBoxLabeled
        Left = 8
        Top = 298
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Nombre de pages'
        TabOrder = 3
        LinkControls = <
          item
            Control = CheckBox33
          end>
      end
      object edAnneeCote: TEditLabeled
        Left = 144
        Top = 320
        Width = 361
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        ReadOnly = True
        TabOrder = 4
        LinkControls = <
          item
            Control = Label24
          end>
        TypeDonnee = tdEntier
        CurrencyChar = #0
      end
      object Label24: TCheckBoxLabeled
        Left = 8
        Top = 322
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Ann'#233'e de la cotation'
        TabOrder = 5
        LinkControls = <
          item
            Control = Label24
          end>
      end
      object edPrixCote: TEditLabeled
        Left = 144
        Top = 344
        Width = 361
        Height = 21
        AutoSelect = False
        AutoSize = False
        BevelKind = bkTile
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 6
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
        Top = 346
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Cote'
        TabOrder = 7
        LinkControls = <
          item
            Control = Label25
          end>
      end
      object cklImages: TCheckListBoxLabeled
        Left = 144
        Top = 368
        Width = 258
        Height = 102
        BevelKind = bkTile
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 13
        TabOrder = 8
        OnClick = cklImagesClick
        LinkControls = <
          item
            Control = CheckBoxLabeled1
          end>
      end
      object CheckBoxLabeled1: TCheckBoxLabeled
        Left = 8
        Top = 368
        Width = 130
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Images'
        TabOrder = 9
        LinkControls = <
          item
            Control = CheckBoxLabeled1
          end>
      end
      object CheckBox32: TCheckBoxLabeled
        Left = 8
        Top = 276
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
