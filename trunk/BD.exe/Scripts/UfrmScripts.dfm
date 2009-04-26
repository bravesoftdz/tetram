object frmScripts: TfrmScripts
  Left = 397
  Top = 157
  Caption = 'Script'
  ClientHeight = 670
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl2: TPageControl
    Left = 0
    Top = 0
    Width = 862
    Height = 641
    ActivePage = tbEdition
    Align = alClient
    PopupMenu = PopupMenu1
    Style = tsButtons
    TabOrder = 0
    OnChange = PageControl2Change
    object tbScripts: TTabSheet
      Caption = 'Scripts'
      ImageIndex = 1
      object ToolBar1: TToolBar
        Left = 0
        Top = 0
        Width = 854
        Height = 22
        AutoSize = True
        Caption = 'ToolBar1'
        DoubleBuffered = True
        DrawingStyle = dsGradient
        GradientEndColor = clBtnFace
        HotImages = frmFond.boutons_16x16_hot
        Images = frmFond.boutons_16x16_norm
        GradientDrawingOptions = [gdoGradient]
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Transparent = True
        object ToolButton1: TToolButton
          Left = 0
          Top = 0
          Cursor = crHandPoint
          Action = actRunWithoutDebug
        end
        object ToolButton2: TToolButton
          Left = 23
          Top = 0
          Cursor = crHandPoint
          Action = actEdit
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 22
        Width = 854
        Height = 588
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 1
        DesignSize = (
          854
          588)
        object Panel4: TPanel
          Left = 0
          Top = 6
          Width = 854
          Height = 257
          Anchors = [akLeft, akTop, akRight]
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Splitter3: TSplitter
            Left = 621
            Top = 0
            Height = 257
            Align = alRight
            ExplicitLeft = 629
            ExplicitTop = 4
            ExplicitHeight = 39
          end
          object ListBox2: TListBox
            Left = 624
            Top = 0
            Width = 230
            Height = 257
            Style = lbVirtual
            Align = alRight
            BevelKind = bkTile
            BorderStyle = bsNone
            ItemHeight = 16
            TabOrder = 0
            OnData = ListBox1Data
            OnDblClick = ListBox1DblClick
          end
          object ListView1: TListView
            Left = 0
            Top = 0
            Width = 621
            Height = 257
            Align = alClient
            BevelKind = bkTile
            BorderStyle = bsNone
            Columns = <>
            HideSelection = False
            ReadOnly = True
            TabOrder = 1
            ViewStyle = vsList
            OnDblClick = ListView1DblClick
            OnSelectItem = ListView1SelectItem
          end
        end
      end
    end
    object tbEdition: TTabSheet
      Caption = 'Edition'
      object Splitter1: TSplitter
        Left = 0
        Top = 420
        Width = 854
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 369
      end
      object ToolBar2: TToolBar
        Left = 0
        Top = 0
        Width = 854
        Height = 22
        AutoSize = True
        Caption = 'ToolBar2'
        DoubleBuffered = True
        DrawingStyle = dsGradient
        GradientEndColor = clBtnFace
        HotImages = frmFond.boutons_16x16_hot
        Images = frmFond.boutons_16x16_norm
        GradientDrawingOptions = [gdoGradient]
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Transparent = True
        object ToolButton3: TToolButton
          Left = 0
          Top = 0
          Cursor = crHandPoint
          Action = actCompile
        end
        object ToolButton4: TToolButton
          Left = 23
          Top = 0
          Cursor = crHandPoint
          Action = actRun
        end
        object ToolButton7: TToolButton
          Left = 46
          Top = 0
          Action = actPause
        end
        object ToolButton5: TToolButton
          Left = 69
          Top = 0
          Width = 8
          Caption = 'ToolButton5'
          ImageIndex = 15
          Style = tbsSeparator
        end
        object ToolButton6: TToolButton
          Left = 77
          Top = 0
          Cursor = crHandPoint
          Action = actReset
        end
      end
      object pcScripts: TPageControl
        Left = 0
        Top = 22
        Width = 854
        Height = 398
        Align = alClient
        PopupMenu = PopupMenu1
        TabOrder = 1
        OnChange = pcScriptsChange
      end
      object Panel1: TPanel
        Left = 0
        Top = 424
        Width = 854
        Height = 186
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 2
        object Splitter2: TSplitter
          Left = 629
          Top = 0
          Height = 186
          Align = alRight
          ExplicitLeft = 637
          ExplicitTop = 20
          ExplicitHeight = 220
        end
        object PageControl1: TPageControl
          Left = 0
          Top = 0
          Width = 629
          Height = 186
          ActivePage = TabSheet1
          Align = alClient
          TabOrder = 0
          object TabSheet1: TTabSheet
            Caption = 'Messages'
            object vstMessages: TVirtualStringTree
              Left = 0
              Top = 0
              Width = 621
              Height = 158
              Align = alClient
              BevelKind = bkTile
              BorderStyle = bsNone
              Header.AutoSizeIndex = 3
              Header.Font.Charset = DEFAULT_CHARSET
              Header.Font.Color = clWindowText
              Header.Font.Height = -11
              Header.Font.Name = 'MS Sans Serif'
              Header.Font.Style = []
              Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
              Header.Style = hsPlates
              TabOrder = 0
              TreeOptions.PaintOptions = [toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toFullRowSelect]
              OnDblClick = vstMessagesDblClick
              OnGetText = vstMessagesGetText
              Columns = <
                item
                  Position = 0
                  Width = 100
                  WideText = 'Contexte'
                end
                item
                  Position = 1
                  Width = 120
                  WideText = 'Type'
                end
                item
                  Position = 2
                  Width = 150
                  WideText = 'Fichier'
                end
                item
                  Position = 3
                  Width = 247
                  WideText = 'Message'
                end>
            end
          end
          object TabSheet2: TTabSheet
            Caption = 'Points de suivi'
            ImageIndex = 1
            object vstSuivis: TVirtualStringTree
              Left = 0
              Top = 0
              Width = 621
              Height = 158
              Align = alClient
              BevelKind = bkTile
              BorderStyle = bsNone
              CheckImageKind = ckSystem
              Header.AutoSizeIndex = 1
              Header.Font.Charset = DEFAULT_CHARSET
              Header.Font.Color = clWindowText
              Header.Font.Height = -11
              Header.Font.Name = 'MS Sans Serif'
              Header.Font.Style = []
              Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
              Header.Style = hsPlates
              TabOrder = 0
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
              OnChecked = vstSuivisChecked
              OnEditing = vstSuivisEditing
              OnGetText = vstSuivisGetText
              OnPaintText = vstSuivisPaintText
              OnInitNode = vstSuivisInitNode
              OnNewText = vstSuivisNewText
              Columns = <
                item
                  Position = 0
                  Width = 146
                  WideText = 'Expression'
                end
                item
                  Position = 1
                  Width = 471
                  WideText = 'Valeur'
                end>
            end
          end
          object TabSheet3: TTabSheet
            Caption = 'Points d'#39'arr'#234't'
            ImageIndex = 2
            object vstBreakpoints: TVirtualStringTree
              Left = 0
              Top = 0
              Width = 621
              Height = 158
              Align = alClient
              BevelKind = bkTile
              BorderStyle = bsNone
              CheckImageKind = ckSystem
              Header.AutoSizeIndex = 1
              Header.Font.Charset = DEFAULT_CHARSET
              Header.Font.Color = clWindowText
              Header.Font.Height = -11
              Header.Font.Name = 'MS Sans Serif'
              Header.Font.Style = []
              Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
              Header.Style = hsPlates
              TabOrder = 0
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toFullRowSelect]
              OnChecked = vstBreakpointsChecked
              OnDblClick = vstBreakpointsDblClick
              OnGetText = vstBreakpointsGetText
              OnPaintText = vstBreakpointsPaintText
              OnInitNode = vstBreakpointsInitNode
              Columns = <
                item
                  Position = 0
                  Width = 100
                  WideText = 'Position'
                end
                item
                  Position = 1
                  Width = 517
                  WideText = 'Fichier'
                end>
            end
          end
          object TabSheet6: TTabSheet
            Caption = 'Sortie'
            ImageIndex = 3
            object mmConsole: TMemo
              Left = 0
              Top = 0
              Width = 621
              Height = 158
              Align = alClient
              BevelKind = bkTile
              BorderStyle = bsNone
              ScrollBars = ssBoth
              TabOrder = 0
              WantTabs = True
              OnChange = mmConsoleChange
            end
          end
        end
        object Panel3: TPageControl
          Left = 632
          Top = 0
          Width = 222
          Height = 186
          ActivePage = TabSheet4
          Align = alRight
          TabOrder = 1
          object TabSheet4: TTabSheet
            Caption = 'Options'
            object ListBox1: TListBox
              Left = 0
              Top = 0
              Width = 214
              Height = 158
              Style = lbVirtual
              Align = alClient
              BevelKind = bkTile
              BorderStyle = bsNone
              ItemHeight = 16
              PopupMenu = PopupMenu2
              TabOrder = 0
              OnData = ListBox1Data
              OnDblClick = ListBox1DblClick
            end
          end
        end
      end
    end
  end
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 641
    Width = 862
    Height = 29
    Align = alBottom
    TabOrder = 1
    Visible = False
    ExplicitTop = 641
    ExplicitWidth = 862
    DesignSize = (
      862
      29)
    inherited btnOK: TButton
      Left = 699
      Visible = False
      ExplicitLeft = 699
    end
    inherited btnAnnuler: TButton
      Left = 779
      Caption = 'Fermer'
      ExplicitLeft = 779
    end
  end
  object SynPasSyn1: TSynPasSyn
    PackageSource = False
    Left = 328
  end
  object SynEditSearch1: TSynEditSearch
    Left = 296
  end
  object ActionList1: TActionList
    Images = frmFond.boutons_32x32_hot
    OnUpdate = ActionList1Update
    Left = 480
    object EditCut1: TAction
      Category = 'Edition'
      Caption = 'Cou&per'
      Hint = 'Couper|Couper la s'#233'lection et la mettre dans le Presse-papiers'
      ShortCut = 16472
      OnExecute = EditCut1Execute
    end
    object EditCopy1: TAction
      Category = 'Edition'
      Caption = '&Copier'
      Hint = 'Copier|Copier la s'#233'lection et la mettre dans le Presse-papiers'
      ShortCut = 16451
      OnExecute = EditCopy1Execute
    end
    object EditPaste1: TAction
      Category = 'Edition'
      Caption = 'Co&ller'
      Hint = 'Coller|Ins'#233'rer le contenu du Presse-papiers'
      ShortCut = 16470
      OnExecute = EditPaste1Execute
    end
    object EditSelectAll1: TAction
      Category = 'Edition'
      Caption = '&Tout s'#233'lectionner'
      Hint = 'Tout s'#233'lectionner|S'#233'lectionner l'#39'int'#233'gralit'#233' du document'
      ShortCut = 16449
      OnExecute = EditSelectAll1Execute
    end
    object EditUndo1: TAction
      Category = 'Edition'
      Caption = '&D'#233'faire'
      Hint = 'D'#233'faire|R'#233'tablir la derni'#232're action'
      ShortCut = 16474
      OnExecute = EditUndo1Execute
    end
    object SearchFind1: TAction
      Category = 'Chercher'
      Caption = '&Chercher...'
      Hint = 'Chercher|Rechercher le texte sp'#233'cifi'#233
      ImageIndex = 34
      ShortCut = 16454
      OnExecute = SearchFind1Execute
    end
    object SearchFindNext1: TAction
      Category = 'Chercher'
      Caption = '&Occurrence suivante'
      Hint = 'Occurrence suivante|R'#233'p'#233'ter la derni'#232're recherche'
      ImageIndex = 33
      ShortCut = 114
      OnExecute = SearchFindNext1Execute
    end
    object SearchReplace1: TAction
      Category = 'Chercher'
      Caption = '&Remplacer'
      Hint = 'Remplacer|Remplacer le texte par un autre texte'
      ImageIndex = 32
      ShortCut = 16466
      OnExecute = SearchFind1Execute
    end
    object EditRedo1: TAction
      Category = 'Edition'
      Caption = 'Refaire'
      ShortCut = 16473
      OnExecute = EditRedo1Execute
    end
    object actRun: TAction
      Category = 'Script'
      Caption = 'Ex'#233'cuter'
      ImageIndex = 14
      ShortCut = 120
      OnExecute = actRunExecute
    end
    object actPause: TAction
      Category = 'Script'
      Caption = 'Pause'
      ImageIndex = 20
      ShortCut = 120
      OnExecute = actPauseExecute
    end
    object actCompile: TAction
      Category = 'Script'
      Caption = 'Compiler'
      ImageIndex = 19
      ShortCut = 16504
      OnExecute = actCompileExecute
    end
    object actStepOver: TAction
      Category = 'Script'
      Caption = 'Pas '#224' pas'
      ShortCut = 119
      OnExecute = actStepOverExecute
    end
    object actStepInto: TAction
      Category = 'Script'
      Caption = 'Pas '#224' pas approfondi'
      ShortCut = 118
      OnExecute = actStepIntoExecute
    end
    object actReset: TAction
      Category = 'Script'
      Caption = 'R'#233'initialiser'
      ImageIndex = 18
      ShortCut = 16497
      OnExecute = actResetExecute
    end
    object actDecompile: TAction
      Category = 'Script'
      Caption = 'D'#233'compiler'
      OnExecute = actDecompileExecute
    end
    object actBreakpoint: TAction
      Category = 'Script'
      Caption = 'Basculer point d'#39'arr'#234't'
      ShortCut = 116
      OnExecute = actBreakpointExecute
    end
    object actAddSuivi: TAction
      Category = 'Script'
      Caption = 'Ajouter point de suivi'
      ShortCut = 16500
      OnExecute = actAddSuiviExecute
    end
    object actRunToCursor: TAction
      Category = 'Script'
      Caption = 'Jusqu'#39'au curseur'
      ShortCut = 115
      OnExecute = actRunToCursorExecute
    end
    object actFermer: TAction
      Category = 'Editeur'
      Caption = 'Fermer'
      ShortCut = 16499
      OnExecute = actFermerExecute
    end
    object actEnregistrer: TAction
      Category = 'Editeur'
      Caption = 'Enregistrer'
      ShortCut = 16467
      OnExecute = actEnregistrerExecute
    end
    object actEnregistrerSous: TAction
      Category = 'Editeur'
      Caption = 'Enregistrer sous...'
      OnExecute = actEnregistrerSousExecute
    end
    object actRunWithoutDebug: TAction
      Category = 'Script'
      Caption = 'Ex'#233'cuter sans d'#233'buguer'
      ImageIndex = 14
      ShortCut = 8312
      OnExecute = actRunWithoutDebugExecute
    end
    object actEdit: TAction
      Category = 'Script'
      Caption = 'Modifier'
      ImageIndex = 13
      OnExecute = actEditExecute
    end
    object actCreerOption: TAction
      Category = 'Script'
      Caption = 'Cr'#233'er une option'
      OnExecute = actCreerOptionExecute
    end
    object actRetirerOption: TAction
      Category = 'Script'
      Caption = 'Retirer une option'
      OnExecute = actRetirerOptionExecute
    end
    object actModifierOption: TAction
      Category = 'Script'
      Caption = 'Modifier une option'
      OnExecute = actModifierOptionExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 440
    object Edition1: TMenuItem
      Caption = '&Edition'
      object Dfaire1: TMenuItem
        Action = EditUndo1
      end
      object Refaire1: TMenuItem
        Action = EditRedo1
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Couper1: TMenuItem
        Action = EditCut1
      end
      object Copier1: TMenuItem
        Action = EditCopy1
      end
      object Coller1: TMenuItem
        Action = EditPaste1
      end
      object Copier2: TMenuItem
        Caption = '-'
        Hint = 'Copier|Copier la s'#233'lection et la mettre dans le Presse-papiers'
        ImageIndex = 1
        ShortCut = 16451
      end
      object outslectionner1: TMenuItem
        Action = EditSelectAll1
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Chercher1: TMenuItem
        Action = SearchFind1
      end
      object Chercher2: TMenuItem
        Action = SearchReplace1
      end
      object Remplacer1: TMenuItem
        Action = SearchFindNext1
      end
    end
    object Run1: TMenuItem
      Caption = 'Projet'
      object Decompile1: TMenuItem
        Action = actDecompile
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Basculerpointdarrt1: TMenuItem
        Action = actBreakpoint
      end
      object actAddSuivi1: TMenuItem
        Action = actAddSuivi
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object StepOver1: TMenuItem
        Action = actStepOver
      end
      object StepInto1: TMenuItem
        Action = actStepInto
      end
      object Jusquaucurseur1: TMenuItem
        Action = actRunToCursor
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Reset1: TMenuItem
        Action = actReset
      end
      object a1: TMenuItem
        Action = actCompile
      end
      object Run2: TMenuItem
        Action = actRun
      end
      object Excutersansdbuguer1: TMenuItem
        Action = actRunWithoutDebug
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 408
    object Fermer1: TMenuItem
      Action = actFermer
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Enregistrer1: TMenuItem
      Action = actEnregistrer
    end
    object Enregistrersous1: TMenuItem
      Action = actEnregistrerSous
    end
  end
  object SynEditParamShow: TSynCompletionProposal
    DefaultType = ctParams
    Options = [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter]
    EndOfTokenChr = '()[]. '
    TriggerChars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <>
    OnExecute = SynEditParamShowExecute
    ShortCut = 8224
    Left = 224
  end
  object SynEditAutoComplete: TSynCompletionProposal
    Options = [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter]
    EndOfTokenChr = '()[]. '
    TriggerChars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <
      item
        BiggestWord = 'constructor'
      end>
    OnExecute = SynEditAutoCompleteExecute
    ShortCut = 16416
    Left = 260
  end
  object PopupMenu2: TPopupMenu
    Left = 520
    Top = 8
    object Creruneoption1: TMenuItem
      Action = actCreerOption
    end
    object Modifieruneoption1: TMenuItem
      Action = actModifierOption
    end
    object Retireruneoption1: TMenuItem
      Action = actRetirerOption
    end
  end
  object lstDebugImages: TPngImageList
    ColorDepth = cd32Bit
    Height = 17
    Width = 27
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D494844520000001B0000001108060000002C4FD7
          33000000097048597300000B1300000B1301009A9C1800000A4F694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7
          DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1
          114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE1
          7BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E
          11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C0
          07BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08
          801400407A8E42A600404601809D98265300A0040060CB6362E300502D006027
          7FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A
          450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00
          305188852900047B0060C8232378008499001446F2573CF12BAE10E72A000078
          99B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC279
          99193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEA
          BF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225
          EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5
          E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D
          814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9
          582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF35
          00B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D428080380
          6883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC7080000
          44A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64
          801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E
          3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F8
          21C14804128B2420C9881451224B91354831528A542055481DF23D720239875C
          46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD064
          74319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C4
          6C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704
          128145C0093604774220611E4148584C584ED848A8201C243411DA0937090384
          51C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C4
          37241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9
          DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853
          E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1
          B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11
          DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867
          197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA
          0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353
          E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659
          C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CD
          D97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C
          744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48
          AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE7
          53D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E
          4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC5
          35716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F
          8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B
          4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B8
          6549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711
          A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D61676217
          67B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A
          DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD34767
          1767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F5
          9D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5
          D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761
          EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF43
          7F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65
          F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE69
          0E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577
          D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3F
          C62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B
          17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA816
          8C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC
          91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD
          31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507
          C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E
          2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39
          B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D
          6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D
          1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF
          66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97
          CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB5
          61D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49
          FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51D
          D23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9
          F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B
          625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367
          F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8B
          E73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB
          9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393D
          DDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41
          D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43
          058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECB
          AE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C6
          1EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553
          D0A7FB93199393FF040398F3FC63332DDB000002AB4944415478DABD945D4853
          6118C7FFEF3967D36DE9D068752196CE8F96131D915F4325A2F0A2A84843EC26
          BA88A0AE826E024104F12E88A0A0AB0283C01B6F84092211A1CDCCCFCAAF35B7
          339BBACDE93EDC873B1FBD9B52797B0C5F7838EFFB3FEFE1F73ECF79DE3F9165
          194735481AD66135FD55645927328C9E1EE12A9D5B688CD34D36FA0C711C1B0B
          84E398E303F06E470F0FA3EBE732214D906160642957024254F64992F441A5E2
          1EFF2F58B944F02E37993A7F716503E57111EAD25230C567F0839130E4E71149
          25A6B6A2C9D6593EE05C3B042C4760C860F176B4B17D7E155A5106575080EC9A
          1A6499CDE00A0B114926F0D2D68F69DE3536C7075B3CC1705811ACDD6AEAD4A5
          84EE07D32BD0A744482C0B756525B40D0DD0D4D622CB62014B083C9F3EA2F7FD
          2B4CF1BEDE09E7C65345B01BCDE681B685D5EB177C21486991E3A0AEAA82D66A
          85A6BE1E9ABABAF446C4ED76D806FBF16C7C74786C71EDB222D8CDA68AE587D3
          CE1263248164462550198D19485675355445452069DDE5C6FC941D9DDF3F7B86
          265D858A606D8DE782F7675D7946DA69BBFB2F189D2E534A755919388321DDA5
          60FD012CB91CE889AD2706BF38344ACB3849FF97A52C1CFB03CB007372328DC2
          E6E7EFAD378358DAD9428F41EB1C99F8695404BBD554D1D7CCFBEF5C71FB33E5
          3AE029B4A4A00DC3D0A92049182E39893E861D199FF75C5204EBB09EBD2782BC
          BEFBCDCD9AF64B29FD9B210D8EC6825E8BB7E6D3F2CCCA7AD7C2AF60B7429829
          9DCD0B5D4A7C746DD98BD2500CB954CF74268D30CDCE91A783CD5480595F6868
          7479ED36FD4ED93DDB7790632959EE940879D21808935391384D8F1E8121D8A0
          198D9DD063717573C0E10D764593A91925067EC01B7705118228B5BA761235C7
          F5DA966C86298A0A82777D336A4F46E25FDDFEF01BEC792514C38E6A1C29EC37
          79F06AEEEB8CB9410000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D494844520000001B0000001108060000002C4FD7
          330000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002F74944415478DABD945B48944114C7FF33EBAEEE6EEEE2
          3D25945C2D377DD12E60A21241174A34CA1203B1A408EAA9140C124D08A28890
          DEECA505830A0C0B238BB2C2E822566A66C6AAABA6A6AEABEECDEF5BBF5BB31A
          946FED3E786098EFFB73667E73CE9939445114AC95113FAC34C7FC575114BD44
          A9911DE120FBCE64A39339B5B1D9F9543DB6B8E2030D5B574528E97375F08F82
          86B1FF0685903CB6612C5564830C38993C23CBF2EB36CDCFF3CB3E22AEEB3334
          95C29CD4EA68F6160403DB2C13DC35F884ADBB6CD3485892A032252372A309FD
          54C633FB18DC02FFE5A538F138248BD6EAD234987DEC2D77B673964061E12225
          4F92173CB925DFC7F1351CB899A546BC3E0696CC0AA81313E1F6F1A87E741BCF
          0D4372E4211D75B47AADDCB098E3F9C0DB038295E4986BF482587FA6DB06A320
          E1D24E03426AF3D03FDA8F9AE9221C282C47D7502F2A2C17802205DE6F3E2CBC
          E12AA986DC60350BEC8214E567B4140F8C176E9F7182D50857B2231077F518BA
          C54EA85B45E427EC47E35B0BE85E1132C7600FB8794E252580820F1876282FDD
          7AB67B38C5E4E6E163624B9C0A0D655A44EF09076715E0ECE010B14B0BA22610
          EF0948B0EBA77A74B3F1FE0D028615E76E993BDD3B126172715862A25D43509D
          AB85E354385461042404101C12A4660117E793F090F3F01D61E3DAA0602C8D9F
          59BD3237B91697617EFB60A4B87C621D34DB4221CC48505E09B8668B42A493C7
          9558DD709776C21414EC705E7A53FE98FDF89E513B08FC6F76C55AE355B89F1D
          8A449B84B22119A91E092F52E2D04455ED03D1F6DD41C14A73D24E4A208DE57D
          A32AF39F54CAFF38513658263160D4C19291A4F4D8A6EA0626E6EAFF9BB21A66
          F647734B2F48E70AAC9348752EC2C0743FD01FA98B100C46E8D166DE80DE19E7
          B377D65F47D93A57D03066EB0445A99109A9CA9D7591F56E8E85C78E4009A659
          44EF638CF831EE68199C9CABF3F8849E601AF8AADEB8244A1025F9C88897DF11
          65D4ED0BA374A3471427A71C9E8F3E37F769D4EEBA83955E89A0616B656B0AFB
          0D56DF9CEE6E1E9B270000000049454E44AE426082}
        Name = 'PngImage6'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D494844520000001B0000001108060000002C4FD7
          330000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002B44944415478DABD945D4853611CC69FB373DCD7691B1A
          18D6D06CA9F91165916561F4A584681F68560605417751504826082245371589
          174114746157827863A48888814BD1CC8FCC8F3937279B9F6B9BD3CD6DE73DBD
          DB44F2F614BE7038FFF739E7F0E37DCEFFFF30A22862BB1613861597A7FF2589
          7C4890E9A85C44EB6C7AF5328CF88581E8663976CDB5E4C3C4F012E6EDDE7F87
          D17D1D1199D332209E91112D217053798110D2C9C5708FFE172C2D44F0294E1B
          3C5A943B8F34BD00B93A0532F95E8C9A099ADA67E05AF10FACFC5E2F1D1F5A32
          2F38A4C3348110D392B1CF9B77277F166A85084EAE87529303059F45EB44ACAC
          FAF1EA4323FA7F588CA661E745BBCDE391042BBC915EADE543B58FCBA6A1E305
          10C2D2531D845A77122AED710ACC06CB32B0CD74E1E9CBB7F839B0F062A46FBE
          4A12ECCC95ACE67BC5B3978FA5B929888A0C07397F88C24E41A5C9A5C0135413
          E1F3F4E07367239EBFEE6E1F323AF225C1CE5DCD9CACBA6DDE6F48F0633D1091
          11A33444200AFE30AD93298CCA210B7E4DF6E2E1B36F3663AB255112ACE05A86
          B3E2A625D6B0DB874020FA40C6F2112BE5AA54FACFE2C35D0A168B98304FA1F2
          CD9CBFABC5A4926AE3F7CAF2E9ECD4C4B54D5814A801A7D083E5E2A27B711913
          332E3CA9539BFB3AA60C9260174A321B2EE52DDE2A38B218B16B6BA850816121
          A3B79040D036B80BEF1BD88E915EDB7949B0A2F20377058179F7A0C4CAA62751
          2B838834CAE609E984731C306655A3BE29491C1B9CAB991E73D64A8285879A88
          A8A76D7FFFFA593B52F6AC41AB11373A13F0781998EC3C1ABFEA313AE46E1DE8
          7694D1EFA4CDD94682EC0804C56A42988AC23C0F9310EB8BFA49690E971A6D46
          1D2CE3CBCD3693B366D51B1C9412E05BB2311010208448A9D5E2CFD1ED545F54
          2A65C95E6FC8BE3CE7ED21EBBE7EBBD5F391BE16CE4A48866DD7DA56D81F7B32
          63EE431CC9D60000000049454E44AE426082}
        Name = 'PngImage7'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D494844520000001B0000001108060000002C4FD7
          33000000097048597300000B1300000B1301009A9C1800000A4F694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53675453E9163DF7
          DEF4424B8880944B6F5215082052428B801491262A2109104A8821A1D91551C1
          114545041BC8A088038E8E808C15512C0C8A0AD807E421A28E83A3888ACAFBE1
          7BA36BD6BCF7E6CDFEB5D73EE7ACF39DB3CF07C0080C9648335135800CA9421E
          11E083C7C4C6E1E42E40810A2470001008B3642173FD230100F87E3C3C2B22C0
          07BE000178D30B0800C04D9BC0301C87FF0FEA42995C01808401C07491384B08
          801400407A8E42A600404601809D98265300A0040060CB6362E300502D006027
          7FE6D300809DF8997B01005B94211501A09100201365884400683B00ACCF568A
          450058300014664BC43900D82D00304957664800B0B700C0CE100BB200080C00
          305188852900047B0060C8232378008499001446F2573CF12BAE10E72A000078
          99B23CB9243945815B082D710757572E1E28CE49172B14366102619A402EC279
          99193281340FE0F3CC0000A0911511E083F3FD78CE0EAECECE368EB60E5F2DEA
          BF06FF226262E3FEE5CFAB70400000E1747ED1FE2C2FB31A803B06806DFEA225
          EE04685E0BA075F78B66B20F40B500A0E9DA57F370F87E3C3C45A190B9D9D9E5
          E4E4D84AC4425B61CA577DFE67C25FC057FD6CF97E3CFCF7F5E0BEE22481325D
          814704F8E0C2CCF44CA51CCF92098462DCE68F47FCB70BFFFC1DD322C44962B9
          582A14E35112718E449A8CF332A52289429229C525D2FF64E2DF2CFB033EDF35
          00B06A3E017B912DA85D6303F64B27105874C0E2F70000F2BB6FC1D428080380
          6883E1CF77FFEF3FFD47A02500806649927100005E44242E54CAB33FC7080000
          44A0812AB0411BF4C1182CC0061CC105DCC10BFC6036844224C4C24210420A64
          801C726029AC82422886CDB01D2A602FD4401D34C051688693700E2EC255B80E
          3D700FFA61089EC128BC81090441C808136121DA8801628A58238E08179985F8
          21C14804128B2420C9881451224B91354831528A542055481DF23D720239875C
          46BA913BC8003282FC86BC47319481B2513DD40CB543B9A8371A8446A20BD064
          74319A8F16A09BD072B41A3D8C36A1E7D0AB680FDA8F3E43C730C0E8180733C4
          6C302EC6C342B1382C099363CBB122AC0CABC61AB056AC03BB89F563CFB17704
          128145C0093604774220611E4148584C584ED848A8201C243411DA0937090384
          51C2272293A84BB426BA11F9C4186232318758482C23D6128F132F107B8843C4
          37241289433227B9900249B1A454D212D246D26E5223E92CA99B34481A2393C9
          DA646BB20739942C202BC885E49DE4C3E433E41BE421F25B0A9D624071A4F853
          E22852CA6A4A19E510E534E5066598324155A39A52DDA8A15411358F5A42ADA1
          B652AF5187A81334759A39CD8316494BA5ADA295D31A681768F769AFE874BA11
          DD951E4E97D057D2CBE947E897E803F4770C0D861583C7886728199B18071867
          197718AF984CA619D38B19C754303731EB98E7990F996F55582AB62A7C1591CA
          0A954A9526951B2A2F54A9AAA6AADEAA0B55F355CB548FA95E537DAE46553353
          E3A909D496AB55AA9D50EB531B5367A93BA887AA67A86F543FA47E59FD890659
          C34CC34F43A451A0B15FE3BCC6200B6319B3782C216B0DAB86758135C426B1CD
          D97C762ABB98FD1DBB8B3DAAA9A13943334A3357B352F394663F07E39871F89C
          744E09E728A797F37E8ADE14EF29E2291BA6344CB931655C6BAA96979658AB48
          AB51AB47EBBD36AEEDA79DA6BD45BB59FB810E41C74A275C2747678FCE059DE7
          53D953DDA70AA7164D3D3AF5AE2EAA6BA51BA1BB4477BF6EA7EE989EBE5E809E
          4C6FA7DE79BDE7FA1C7D2FFD54FD6DFAA7F5470C5806B30C2406DB0CCE183CC5
          35716F3C1D2FC7DBF151435DC34043A561956197E18491B9D13CA3D5468D460F
          8C69C65CE324E36DC66DC6A326062621264B4DEA4DEE9A524DB9A629A63B4C3B
          4CC7CDCCCDA2CDD699359B3D31D732E79BE79BD79BDFB7605A785A2CB6A8B6B8
          6549B2E45AA659EEB6BC6E855A3959A558555A5DB346AD9DAD25D6BBADBBA711
          A7B94E934EAB9ED667C3B0F1B6C9B6A9B719B0E5D806DBAEB66DB67D61676217
          67B7C5AEC3EE93BD937DBA7D8DFD3D070D87D90EAB1D5A1D7E73B472143A563A
          DE9ACE9CEE3F7DC5F496E92F6758CF10CFD833E3B613CB29C4699D539BD34767
          1767B97383F3888B894B82CB2E973E2E9B1BC6DDC8BDE44A74F5715DE17AD2F5
          9D9BB39BC2EDA8DBAFEE36EE69EE87DC9FCC349F299E593373D0C3C843E051E5
          D13F0B9F95306BDFAC7E4F434F8167B5E7232F632F9157ADD7B0B7A577AAF761
          EF173EF63E729FE33EE33C37DE32DE595FCC37C0B7C8B7CB4FC36F9E5F85DF43
          7F23FF64FF7AFFD100A78025016703898141815B02FBF87A7C21BF8E3F3ADB65
          F6B2D9ED418CA0B94115418F82AD82E5C1AD2168C8EC90AD21F7E798CE91CE69
          0E85507EE8D6D00761E6618BC37E0C2785878557863F8E7088581AD131973577
          D1DC4373DF44FA449644DE9B67314F39AF2D4A352A3EAA2E6A3CDA37BA34BA3F
          C62E6659CCD5589D58496C4B1C392E2AAE366E6CBEDFFCEDF387E29DE20BE37B
          17982FC85D7079A1CEC2F485A716A92E122C3A96404C884E3894F041102AA816
          8C25F21377258E0A79C21DC267222FD136D188D8435C2A1E4EF2482A4D7A92EC
          91BC357924C533A52CE5B98427A990BC4C0D4CDD9B3A9E169A76206D323D3ABD
          31839291907142AA214D93B667EA67E66676CBAC6585B2FEC56E8BB72F1E9507
          C96BB390AC05592D0AB642A6E8545A28D72A07B267655766BFCD89CA3996AB9E
          2BCDEDCCB3CADB90379CEF9FFFED12C212E192B6A5864B572D1D58E6BDAC6A39
          B23C7179DB0AE315052B865606AC3CB88AB62A6DD54FABED5797AE7EBD267A4D
          6B815EC1CA82C1B5016BEB0B550AE5857DEBDCD7ED5D4F582F59DFB561FA869D
          1B3E15898AAE14DB1797157FD828DC78E51B876FCABF99DC94B4A9ABC4B964CF
          66D266E9E6DE2D9E5B0E96AA97E6970E6E0DD9DAB40DDF56B4EDF5F645DB2F97
          CD28DBBB83B643B9A3BF3CB8BC65A7C9CECD3B3F54A454F454FA5436EED2DDB5
          61D7F86ED1EE1B7BBCF634ECD5DB5BBCF7FD3EC9BEDB5501554DD566D565FB49
          FBB3F73FAE89AAE9F896FB6D5DAD4E6D71EDC703D203FD07230EB6D7B9D4D51D
          D23D54528FD62BEB470EC71FBEFE9DEF772D0D360D558D9CC6E223704479E4E9
          F709DFF71E0D3ADA768C7BACE107D31F761D671D2F6A429AF29A469B539AFB5B
          625BBA4FCC3ED1D6EADE7AFC47DB1F0F9C343C59794AF354C969DAE982D39367
          F2CF8C9D959D7D7E2EF9DC60DBA2B67BE763CEDF6A0F6FEFBA1074E1D245FF8B
          E73BBC3BCE5CF2B874F2B2DBE51357B8579AAF3A5F6DEA74EA3CFE93D34FC7BB
          9CBB9AAEB95C6BB9EE7ABDB57B66F7E91B9E37CEDDF4BD79F116FFD6D59E393D
          DDBDF37A6FF7C5F7F5DF16DD7E7227FDCECBBBD97727EEADBC4FBC5FF440ED41
          D943DD87D53F5BFEDCD8EFDC7F6AC077A0F3D1DC47F7068583CFFE91F58F0F43
          058F998FCB860D86EB9E383E3939E23F72FDE9FCA743CF64CF269E17FEA2FECB
          AE17162F7EF8D5EBD7CED198D1A197F29793BF6D7CA5FDEAC0EB19AFDBC6C2C6
          1EBEC97833315EF456FBEDC177DC771DEFA3DF0F4FE47C207F28FF68F9B1F553
          D0A7FB93199393FF040398F3FC63332DDB0000004A4944415478DAEDD0310E00
          2008034078167E8D99B7F1ACCAA4938B11E240571A2E2903A0AA70638D5D61EE
          8E21120D234039158BEFA045BC01CF185B1CB406DB20E5CF9891C61AFB079B81
          5746DF1E7F196E0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D494844520000001B0000001108060000002C4FD7
          330000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001D54944415478DA63FCFFFF3F03BD00E390B38C919111C6
          6402E27FD8D480ECA18E658E8C1CBC7FD8F60259E2FFFF33A67E39FA633FCD2C
          E3B7E5C8039A3291438E85E1C7A33F200367B370FC2C7BBF87E123D52DE3B5E1
          98C4A9C89A2B1122C020F74185E1E8F2130C7FBFFE7FCAF4FF5FC0C7A3BFCF10
          B4ECF8F1E3FFAD2C2D8121D30A5458CD88CF327E5BCE55427E5CA1821ABC0CBD
          A63319763CD8C4307FF242902FBF00A333E4D3E19F3BF15A0634FD3F03DC0AFC
          16F2D9721C9288E1B565156701F335F97518FEFEFDC77074D129861FF77FFF06
          9AA4FBE9C88F9BB82D636C054A54136BD92D89783E5556116614F19F4FFF30BC
          5AF119C4ECFA74F84739DE388358C84030188196BD100EE412E7946563606485
          28FDF3F91FC3A713DF19BE5EFAF5F42F23B3E9D7435F9F532581F0D9729E11F2
          E53466E1676660E16662F8FDE92FC39F777F19DEEFFCFE9D89E19FEDC723BFCF
          522D35F2D970ACE1B5E20866136702F3FFFF616478BFFD2BC3BF3FFF23BE1CFD
          B512123AD4B2CC8EB38D898BA152D09593E1D7ABBF0C9F8FFDFC0F4C14659F8F
          FEEC81A9A1623E63D70616599781A9971168C917A0A9319F0FFFDA88AC867AC5
          153033F1DA72A4002D5261FCFB7FCEA7E33FEFA0ABA19A65443B8A9E9601003B
          BEFBDFD38B62E60000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D494844520000001B0000001108060000002C4FD7
          330000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000004424944415478DABD945B4C1C5518C7FF67F6C2CE6E77D7
          05DA05A2341450107CA015931616428C55A3584841893615AD35265E1EB4AD6D
          22696D5263AA8DC13ED99A28A68D6D630D259882E9450BDB22A10AB42295CB02
          B2145816D81B33B373F3CC22EDA2D6071FFA25933973E63BE7F7DD89AAAAB85B
          4234D8F345B9B77754D522338C9D9AF0345D17D0A7932AB5D077E0AC616C6151
          07467A6E2761C8F5601B7FE67FC3E877BD4A4809BD7015A32A360508D0ED6945
          517E6831FEF1764C47C247967CE30E71566EF69F8E941342968E33F451FE0DA4
          71E2610F2804C76D82B8AECC3385B4A80C5DE61A246664A28F51D0EA1B4348E4
          7F392F799BF46B99BDE61C23669A22B5810B5C03292326AB643C4F6D77AA2AD9
          1E76F317FF0B669518F2DD9AF9B0ABE6B7715CB3029FAC3520D5B2120D05DB60
          484F4748E0B1FBCC517C6F1B52122BCD8CBF3932C00D4B45E10EDE677799DEA2
          61AF37A5EBC18F495A111CD59B845D73E76251590EAB29CAADB388D2FED7BA3D
          B08B32DEDB60837E6F09FA46FB50375581A736D5A26BA817DB1ADE012A54447E
          1530FF23B7833192433467B0169B3E65330C6FA654DD83F4F92CB8BFEE801C51
          BD340D1501B7D8B50C56519ADF58DD3FBEA9703A100BF881F50E383F7C0EDD52
          270CCD124AD39EC491F606308F4B50380A3BC5CD713A398D6688D76076177B2A
          F11973B523C78A43859FA165A4095F1C6ED0BC0CD3745605DB84D65BB0CA92BC
          81D7BB87B332433C040A6B74EA50BF9545F2462BB8011181360E8E3216C44020
          9D1091E6B34CF6986752358B3598CD65BA94B2C5EA3238F5B190E5DAF321CB0A
          DC5F7582F788222DB68782EDFC8D18ACDAF5E0ECABBD238ECC20872855F61909
          76BB58F8B75BA13311107A87E897219F16B1676E35BEE5C27C9B699C8D83FD9E
          F2A22DDB90AC5B56148257C2F48990B63C48F5DE5D0AE3CF345F05F707176230
          4D3AEC0CDE7F69058C0F27409C96A15E1471D09384C4008F03ABCCC35DAC3733
          0E3699546976B2F71963DE6B228514043B38447AA35E99E80A2397223763B0CD
          2579C74AC77C2F6C1CF581C47A76519A537538B93E01E91E195B87146487659C
          CB72E218A3BBD09FEC7BF4368CED4A2C67D7E9ED3AE82D0CC4A00C6956C65C2B
          C731505C8176F16A5CE9E7BC2C831CA9BD3EAACBFD2B94F19DA975AA968D7EBB
          190DF9ABD51ECFE4BE7EEFECFEA5FFB662D337D60DA6CD4627B358E612C1DCD9
          081449AD09BBA327FFD1D4D49BC316517EA37C6002D98105D8E8BE06D43C0DD2
          921A7458D0927B2F7AA703AD97076E3E4BCF056FC14AD80F1833F6381E6311A5
          210F5D16547AE1AE905BF8F84E136485A8AA750A213B5D33419212E2A87BD404
          86608A7A7465A51D37C6FD8D8313B3FBC282D8133FC0ADC5097974645DA39611
          0A09D35BB784DAA2CB66E6DF61884A34D6B2523512E11F49B29B9F30314C4658
          922626FDE19F84107775D417FC128BB312F1306D365A5DA65728288BC8EAE7C1
          2BC2E01DC7D5DD92BB0AFB13114651FDA886C1440000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D494844520000001B0000001108060000002C4FD7
          330000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001A44944415478DAD594CF2B445114C7CF7DF366DC377A86
          A1663694A2082BD9689EB2B0244259281B962CC93F6021165889121B3FB261C3
          14A9190F890D2B52A426B230E6BD79CDFB7DDD3752C8C2E252EEEDD639A76FE7
          734FE79E8B0821F0570BFD3B1842E8DDE4E871BFD3781C36B05684453BB04FAD
          082168282BEB07BF060B4978846699C1153CE8F7B6977081C7C6687A0F32CC61
          620CCF0A95FEE1684F3154BC5481BC7A028E46521C713B33B275C6B8326123DC
          11EC2DA91161BA691E76EFB661696ED9AB324BDBD9A3248D383358918413D17E
          51F247F8BC5F1BAA07C771415E3905FDD6B280408372A85FB1825D47078AAAFD
          65BE4F712365C3D39AEA99934A521F63057B2CED0A4684F20020FFDB18D8AA0B
          CA490EB40B33E5205F9396D01E18C184B370BBD0C8877CC0177260290ED8CF0E
          A4E3B91C07AE9439B4CED9F52C8637C566DC1D8870799FD808D23B1AB836E9CB
          CAE67A3EC60CD6224C7041182F6913C07C72403D32087D14A3AA6C4CBD6B18CE
          59411DFDB22E01D14D204BB3F6AB4973EBA386DD7745874994F020055521872C
          2AC7C6CD570D33D88F2FF597B057541EE7DF22D24A9E0000000049454E44AE42
          6082}
        Name = 'PngImage4'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D494844520000001B0000001108060000002C4FD7
          330000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000027C4944415478DABD944B6813511486CF649234E6391D4D
          3299B1B512AB2989B4A9E04E372274E1138A9BEE5CBB12DC0885D28DCBFAC08D
          5D545071DB2E040B4552B118855434B626B1A64D6B1E1362A693DA249D3419CF
          8D15A23B47C981CB3FF731F79B73E7BF87525515DA1514815D1E1C6C1DB3E098
          03F55C435583A86FB13DC731D940D3E56FDBDB10CBE54094E57F8761FF0ECA69
          6C2E6C7604925DF3A821234D5FFF5FB063F8FCC4A8D79FE01D0E70DBEDC0330C
          589D4E2866B3309F4840A95A7D27572AC39FB2D964BE54D20CB3A13EB3994CA7
          8EBADD80C70507AC56F0F4F6C2FE9E1EB021B0BAB5054F272761717DFD356636
          9491A4BFA635619782C151048CFB791E4C0603503871D0E502DEEF07CEE703A7
          D70B944E07C970186E4F4C40349DBEF56163E3A626D8F9FEFE69AFD37991C3E3
          237D1A37EEE238E00301F0F4F535812472B118BC9A9A82FBA1D05C646DEDAC56
          D8E7E3827084B558A056AF034551E041F0AFACEC0826F1BD50802F0B0B707766
          66633E1EEFD604BB3030500CF07C27633643BDD1684E90E3E43D1E600401CC68
          14B24E4127A6A35178140E57E79697F769CD6C312008C1CE161809B3D1082CBA
          B203CD4242299721258A30BBB4947C994878B566F6586098916E966D1E616B55
          217D6A4FC9877C952408AFAEBEC07F7646130CAD7F15F5818FE36862F95DDCF4
          4FA00E5BF1E785563F6632632BA238AE15469EEFA1FDAF1DC2EC88513AF47A20
          389255A55603BCCC90DEDC84782E371B49A5AEE07BDAEED91ECCBA5BAF8FA2DE
          E862598AFC2F3247B2AA280A64B03CADE4F3D3C94261ACBCB3F35E4B01FFAD36
          12DB2370382BCB2731BB212C5D87CB8A92114BA537A891B4243DC465CDA2A819
          D6AE682BEC07FBBB57EE4EA9B76E0000000049454E44AE426082}
        Name = 'PngImage5'
        Background = clWindow
      end>
    Left = 363
    Bitmap = {}
  end
end
