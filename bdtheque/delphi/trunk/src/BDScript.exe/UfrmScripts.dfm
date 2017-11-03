object frmScripts: TfrmScripts
  Left = 397
  Top = 157
  Caption = 'Script'
  ClientHeight = 670
  ClientWidth = 882
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl2: TPageControl
    Left = 0
    Top = 0
    Width = 882
    Height = 670
    ActivePage = tbScripts
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
        Width = 874
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
        Width = 874
        Height = 617
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 1
        DesignSize = (
          874
          617)
        object Label1: TLabel
          Left = 0
          Top = 485
          Width = 748
          Height = 16
          Caption = 
            'ATTENTION: Dans ce mode, aucune information ne sera ajout'#233'e dans' +
            ' la base de donn'#233'es par l'#39'ex'#233'cution d'#39'un script.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Panel4: TPanel
          Left = 0
          Top = 6
          Width = 874
          Height = 257
          Anchors = [akLeft, akTop, akRight]
          BevelOuter = bvNone
          Caption = 'Panel4'
          ShowCaption = False
          TabOrder = 0
          object Splitter3: TSplitter
            Left = 641
            Top = 0
            Height = 257
            Align = alRight
          end
          object ListBox2: TListBox
            Left = 644
            Top = 0
            Width = 230
            Height = 257
            Style = lbVirtual
            Align = alRight
            BevelKind = bkTile
            BorderStyle = bsNone
            TabOrder = 0
            OnData = ListBox2Data
            OnDblClick = ListBox2DblClick
          end
          object ListView1: TListView
            Left = 0
            Top = 0
            Width = 641
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
        object Panel5: TPanel
          Left = 0
          Top = 269
          Width = 874
          Height = 100
          Anchors = [akLeft, akTop, akRight]
          BevelKind = bkTile
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 1
          DesignSize = (
            870
            96)
          object Label2: TLabel
            Left = 8
            Top = 8
            Width = 45
            Height = 13
            Caption = 'Auteur :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label3: TLabel
            Left = 8
            Top = 46
            Width = 70
            Height = 13
            Caption = 'Description :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label5: TLabel
            Left = 59
            Top = 8
            Width = 31
            Height = 13
            Caption = 'Label2'
          end
          object Label7: TLabel
            Left = 8
            Top = 27
            Width = 48
            Height = 13
            Caption = 'Version :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label8: TLabel
            Left = 62
            Top = 27
            Width = 31
            Height = 13
            Caption = 'Label2'
          end
          object Label9: TLabel
            Left = 264
            Top = 27
            Width = 168
            Height = 13
            Caption = 'Version de BDth'#232'que requise :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label10: TLabel
            Left = 438
            Top = 27
            Width = 31
            Height = 13
            Caption = 'Label2'
          end
          object Label4: TLabel
            Left = 264
            Top = 8
            Width = 128
            Height = 13
            Caption = 'Derni'#232're modification :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label6: TLabel
            Left = 398
            Top = 8
            Width = 31
            Height = 13
            Caption = 'Label2'
          end
          object Memo1: TMemo
            Left = 84
            Top = 46
            Width = 777
            Height = 43
            Anchors = [akLeft, akTop, akRight, akBottom]
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Lines.Strings = (
              'Memo1')
            ParentColor = True
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object Button1: TButton
          Left = 0
          Top = 375
          Width = 93
          Height = 25
          Cursor = crHandPoint
          Caption = 'Mettre '#224' jour'
          TabOrder = 2
          OnClick = Button1Click
        end
      end
    end
    object tbEdition: TTabSheet
      Caption = 'Edition'
      object Splitter1: TSplitter
        Left = 0
        Top = 449
        Width = 874
        Height = 4
        Cursor = crVSplit
        Align = alBottom
      end
      object ToolBar2: TToolBar
        Left = 0
        Top = 0
        Width = 874
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
        Width = 874
        Height = 427
        Align = alClient
        PopupMenu = PopupMenu1
        TabOrder = 1
        OnChange = pcScriptsChange
      end
      object Panel1: TPanel
        Left = 0
        Top = 453
        Width = 874
        Height = 186
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 2
        object Splitter2: TSplitter
          Left = 603
          Top = 0
          Height = 186
          Align = alRight
        end
        object PageControl1: TPageControl
          Left = 0
          Top = 0
          Width = 603
          Height = 186
          ActivePage = tabMessages
          Align = alClient
          TabOrder = 0
          object tabMessages: TTabSheet
            Caption = 'Messages'
            inline framMessages1: TframMessages
              Left = 0
              Top = 0
              Width = 595
              Height = 158
              Align = alClient
              TabOrder = 0
              inherited vstMessages: TVirtualStringTree
                Width = 595
                Height = 158
                OnDblClick = vstMessagesDblClick
                OnGetText = framMessages1vstMessagesGetText
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
                    Width = 221
                    WideText = 'Message'
                  end>
              end
            end
          end
          object tabWatches: TTabSheet
            Caption = 'Points de suivi'
            ImageIndex = 1
            inline framWatches1: TframWatches
              Left = 0
              Top = 0
              Width = 595
              Height = 158
              Align = alClient
              TabOrder = 0
              inherited vstSuivis: TVirtualStringTree
                Width = 595
                Height = 158
                Columns = <
                  item
                    Position = 0
                    Width = 146
                    WideText = 'Expression'
                  end
                  item
                    Position = 1
                    Width = 445
                    WideText = 'Valeur'
                  end>
              end
            end
          end
          object tabBreakpoints: TTabSheet
            Caption = 'Points d'#39'arr'#234't'
            ImageIndex = 2
            inline framBreakpoints1: TframBreakpoints
              Left = 0
              Top = 0
              Width = 595
              Height = 158
              Align = alClient
              TabOrder = 0
              inherited vstBreakpoints: TVirtualStringTree
                Width = 595
                Height = 158
                OnDblClick = vstBreakpointsDblClick
                Columns = <
                  item
                    Position = 0
                    Width = 100
                    WideText = 'Position'
                  end
                  item
                    Position = 1
                    Width = 491
                    WideText = 'Fichier'
                  end>
              end
            end
          end
          object tabConsole: TTabSheet
            Caption = 'Sortie'
            ImageIndex = 3
            object mmConsole: TMemo
              Left = 0
              Top = 0
              Width = 595
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
        inline framScriptInfos1: TframScriptInfos
          Left = 606
          Top = 0
          Width = 268
          Height = 186
          Align = alRight
          TabOrder = 1
          inherited Panel3: TPageControl
            Width = 268
            Height = 186
            inherited TabSheet4: TTabSheet
              inherited ListBox1: TListBox
                Width = 260
                Height = 158
              end
            end
            inherited TabSheet5: TTabSheet
              inherited EditLabeled1: TEditLabeled
                LinkControls = <
                  item
                    Control = framScriptInfos1.Label11
                  end>
              end
              inherited MemoLabeled1: TMemoLabeled
                LinkControls = <
                  item
                    Control = framScriptInfos1.Label14
                  end>
              end
              inherited EditLabeled2: TEditLabeled
                LinkControls = <
                  item
                    Control = framScriptInfos1.Label12
                  end>
              end
              inherited EditLabeled3: TEditLabeled
                LinkControls = <
                  item
                    Control = framScriptInfos1.Label13
                  end>
              end
            end
          end
          inherited PopupMenu2: TPopupMenu
            Top = 40
          end
        end
      end
    end
  end
  object SynEditSearch: TSynEditSearch
    Left = 48
    Top = 112
  end
  object ActionList1: TActionList
    Images = frmFond.boutons_32x32_hot
    OnUpdate = ActionList1Update
    Left = 536
    Top = 8
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
  end
  object MainMenu1: TMainMenu
    Left = 496
    Top = 8
    object mnuEdition: TMenuItem
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
    object mnuProjet: TMenuItem
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
    object mnuAide: TMenuItem
      Caption = 'Aide'
      object mnuAPropos: TMenuItem
        Caption = 'A propos...'
        OnClick = mnuAProposClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 464
    Top = 8
    object Fermer1: TMenuItem
      Action = actFermer
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Enregistrer1: TMenuItem
      Action = actEnregistrer
    end
  end
  object lstDebugImages: TPngImageList
    ColorDepth = cd32Bit
    Height = 17
    Width = 27
    PngImages = <
      item
        Background = clWindow
        Name = 'PngImage0'
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
      end
      item
        Background = clWindow
        Name = 'PngImage6'
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
      end
      item
        Background = clWindow
        Name = 'PngImage7'
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
      end
      item
        Background = clWindow
        Name = 'PngImage1'
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
      end
      item
        Background = clWindow
        Name = 'PngImage2'
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
      end
      item
        Background = clWindow
        Name = 'PngImage3'
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
      end
      item
        Background = clWindow
        Name = 'PngImage4'
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
      end
      item
        Background = clWindow
        Name = 'PngImage5'
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
      end>
    Left = 384
    Top = 8
    Bitmap = {}
  end
  object SynMacroRecorder: TSynMacroRecorder
    RecordShortCut = 24658
    PlaybackShortCut = 24656
    Left = 48
    Top = 160
  end
  object SynCodeCompletion: TSynCompletionProposal
    Options = [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter]
    NbLinesInWindow = 6
    EndOfTokenChr = '()[]. '
    TriggerChars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <
      item
        ColumnWidth = 50
      end
      item
        ColumnWidth = 100
        DefaultFontStyle = [fsBold]
      end>
    OnExecute = SynCodeCompletionExecute
    OnShow = SynCodeCompletionShow
    ShortCut = 16416
    Left = 48
    Top = 208
  end
  object SynParameters: TSynCompletionProposal
    DefaultType = ctParams
    Options = [scoLimitToMatchedText, scoUsePrettyText, scoUseBuiltInTimer]
    ClBackground = clInfoBk
    Width = 262
    EndOfTokenChr = '()[]. '
    TriggerChars = '('
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <>
    OnExecute = SynParametersExecute
    ShortCut = 24608
    Left = 48
    Top = 256
  end
  object dwsDebugger: TdwsDebugger
    Left = 201
    Top = 113
  end
  object boutons_16x16_hot: TPngImageList
    PngImages = <>
    PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    Left = 160
    Top = 56
  end
  object boutons_32x32_norm: TPngImageList
    ColorDepth = cd32Bit
    Height = 32
    Width = 32
    PngImages = <>
    PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    Left = 280
    Top = 8
  end
  object boutons_16x16_norm: TPngImageList
    PngImages = <>
    PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    Left = 280
    Top = 56
  end
  object boutons_32x32_hot: TPngImageList
    Height = 32
    Width = 32
    PngImages = <
      item
        Background = clWindow
        Name = 'PngImage0'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000009264944415478DA
          CD57695493571A7EB242209010F6288830548A082E153D8A55AB587546C70A68
          D1EACCB881B5D6B5CCD116A738E352B771F4B4C288A345C56D14D411AD62A10A
          B81E2B0845050401014102849010922F99F7FB122287D676DAF93173CF7972BF
          BBBDEF73EFBBDC1B1EFEC785F77F4B201408A36A09E11D82C23A9767B6D63C6B
          6D9DDE4650115A7AD52C2E160179FF3181504BDF5AC22677B958347DAC1B18A3
          1906830995F59D28ADEAC0AFFA38C04D2E4697D1040303B4AABBD0D86A8007F5
          19D83E9ADFDC6E805C618FFA06ADAEAE9389AB056E92CC7282F9A7086CA02AA9
          9F970449CB95705658A61C3CD584469511BF9BE9062F77916D7E69B90EFB8E36
          62ED622FF82AEDB8BE0E0D905B64C6A4B7FC5058DC8CCD7F2DEC786A326FA163
          BA42C3B75F4980948FA12AC7432E12C8647C181933BA0C66B469181869570AB9
          00123B3E1C2404AA797CE071951E4B66BB212C4802B15800AD96FA9A24080BF1
          B2C93D9BF514078E97153F047651F306E1E1F708845AEC5CE8ED62D777CD7C05
          446213EC443CE4176A5154A6C7F2580504345B6720E84DB855A443CE9D0E8C18
          24A1E36750F7DC0017272162A202113CD0130C91BF57F402C387B873DFCBD6E6
          A3B0B97353331D1AE9394E607A1338419E356B438C17E42E06CECB9ADA18FCE3
          AB76AC899211211EF5F1B8FEB2DA2E64E46BF1C14C191CEDF99C1013C347498B
          03264E0AE0E4EDFFF221AE153460DFAED1903A8A9075A506C9871F95D0D677D2
          F075AB3F580890727FAACAE60C76E7FB7BEAB85E56D191DB3A8C0914C3DF4D08
          F02D7D9D4620F55A0762474AE0EE2CE0FAD89FBBB5F6888D0B8180CFC3A5EC1A
          5454D761DA14075CCF77C0DCE800E8BB4C58BA2A0F0FDBBB36BF000A68D5859E
          04B6CBC5C2B5514A019AF546A849493D1D731B1D77A88B80840212210FAE121E
          72EB8DF072E023CC5D68514E633A9313C2DE7B0D9E1E12723A150EA63F40662A
          8D93C38F8B31E06F5B23E0EC24C2898C2748CB785250467BA095996CB8F248B9
          3D7D3CF3168B151D5D5D9051434AA820F81204ECF11274D6A0D613DC09E4A390
          11010F3B3164917DF14E943F5ADABA9090780367BE748242ACB2444F963B9E54
          3860FEBB816868D4B1BEA0272758417BCCA7E16296C00C9295112312813118B8
          45D55665837B85E855C21B56526A2B8CCE8E48DC350262111F9B767C8B551F08
          30D8B7D1B6A6D5A0C0D477D548D93306F61425097FBA8DDB95EA943AF23936E2
          58029F8548A509411A8D6DD13558D2A0AC87F2E7D65319D5A34F6C6F0FD7F9FE
          181BA1C485CB3530F19AB07A8EEA7BD96ED926270C0AF2C18437955C48A61E2F
          2B7A046C06EBF844206B9A4231C54EA5E2BC9CC218056633DEA61361DB0CC390
          87339CDB0E842556BB8BD0CF035149A1A87EA6C1E7FBBFC5A97D7C084C3A8B6F
          F428A50D5E58BF518B6D49E1686AEE44FCEA3C6389194BC9B4C7580247C90473
          CCD61CD99D277BCA900A047024F8D08E65544BF97CD81149DE48670C1BE989BD
          FB4BB06FAF1FFAB8769100926036596E0DB6A6B689A445CEACC51F570C45407F
          677CFCE73BB85AD6B691CEEA204B6035E9D849D38DA4547839C3874286414787
          19EA7606ADED66B4500A7E4168A064D3506FA05D30E4501492E49183062B90B8
          210401FDC416FA660B783CEB37574C3875BE05B77255787F5130CE5FAAC6EEF4
          C76935C0E7DC462969F6A5A9CB3D8184826BE1301BB598FD693B94DE6ED068F4
          90CB1D201119F1495403E48EAC600605E5BE081C1800994CCC85A94DB955A1AD
          365BC63232ABB18376CE3AE33F339FE0E8A5EAE34F29D5D84E7A00D08FAE92AA
          7F5D8E84D4DE802DA7FB61DBEE43888F8F4772723252937762003F15A3422524
          D784FC326F8C8808B219CEC498D0AED643DDDA4997911EAF87B85B0493191822
          367DDC1134D66B20958AA0D31951CF98F734B051D0EB3252A71E9BECF45A8023
          361E9662E79E9704CE9C3E0971FD764C1EED461B6570E3A12BC223FCB9758BC6
          FE1DBE6A131CC837585F794A8964EBD53F5809985178AF064BA2D2D9D03E4886
          7227CB353CB364C3A7BD09946CD8F65670E4643F2C4EAA035F2447494909D6AF
          5F4F9B36C15C9F8A5993BDA1D11A50A572C18010251AEBDAB063E201FC5AF132
          3E6E2B85483831D7D6FE64D9495C3E57AA2901569A2DD14CD918222E11F522F0
          D5BCF8E193E2578EC2BADDCDD8BBEF30E6CD9B87E8E868E4E4E420C8AB120BA2
          FAA0B2520591AB129EDECEC8B9508A071FE760B0A3E3CBB01BE381B8AD53B958
          6A69D2E0374377406B32E7530A3E604D3315DD737B1338307A42C082EDFB63F0
          D16735F822F908E2E2E290929282BCBC3C94DFDB8BD8693EB89E5B81A1E303E9
          8614E28BBF7C0DE5B95AB8894436F76B591C8419BF1FC6B52F67162369D95950
          D0B036BF0F4B06D4BE8AC046AF3ECE89193757217A510E0EA59D426262224720
          2B2B0BBAE7C73075821F2E9EB98F89D17EDCF255334F23AA496CB992C9DEAD94
          B4943B466058842F2773DB47D93877EC81FE3BE043C672F4677AEAEC4D6009F5
          A4A4652F414B87091959D5A8AAD561F29419F432E221D8E7014687F7C3F91377
          3065767F6E4DDCD034CC775470CA8FA91BF086832BA69E8E84571F276E7CCEB8
          A328AF68B94FA9770F2C8F919B3F46A03FB1CCA4974FE8F4D850C4AD9B488F13
          296EDDADC5D94B9558BE7008944A19CEA415E0B7EF0572A1F77EF021CCF3F0E0
          D61BC851EFE9B458797736F8F42E685575625A582A5A8174BAE0B2694A0EA1EA
          9504AC1D414A608D0B10E32815CB16AE1985E805E11009ED6C734EEECF43F4C2
          81503569B165EC29CC7075B58DE5F37548F82686FBCEBB5289750B2EB0B76B22
          9178D6DBFE3F4800DC1303AF53BC8EEC0B44916F47F6F593093F4C1A8FD11303
          29AEF9484F2EA0D74F18CA4B5F207DD6254C90CB2D214FB8E169C2F81543F0A8
          B809B917CAF15D61A3BA185845431D5602F82902DD857DA80C7106DEF42653D2
          FE4387BFE98BE59F46A020BB0A73970EC537172B90BBE92EE4F6223CE719F158
          D581E78D1D360114111A6A655702E7A84999175FFF1C02DD85AC8170BA27DE76
          0362C542BE97A7520A7D2783E61ECAAC2760A4274D452725347AACD0E38C53DA
          7D41DC253CF82504BA8B2FD966A40F99C58108D14211396C3329AC25853564D8
          5AFAE3516F7E7913C17AEC74E971F667C1FC3704BAFD231896D79AE807C6DB09
          F4F4471381FE8DB101F0E3E597FE3B66FD83BD0AD94780CEAA9485FEE70AFA37
          F9E29D914ADC3C560000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage1'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000084A4944415478DA
          AD97095054471AC7FF33C30033824A541019512EE510AF2D4F0C1AA0C490788B
          01316874813528B26BE1AA4125680C8B4613C3AA4413DD8D202E51848A469078
          2089B77228824111051DE2017208C3316FBF7EC31B1F23486D65BBEAE3DFBCD7
          F4FFD7C7D7AF91E0FF5CDE9E11A620B1A4E827D25A8A1FCF6724B618B697FC8F
          9DF727B113C5608AFE06863DBAF8F30714CE04D1F84600323127994C31C4C08C
          85A22B3885A9097A9AF7402F8A9EE666144A5E394E8B33BF5C476D5D036B164A
          007B3B0520636F9275AC4A2167CF64322906A9ACE168A742DFB77AF1063A1333
          5E150A2564264AC8E526D042064D8B164D2D1C9A5BB590CB243057C8E0D0DF14
          BBF61F41CAB153ACCB540298FF1A00994F25C9A030B1EC6B8185F3A6C175881D
          5403ACD10A299A9AB568A478A911B48DAFB7B48146C841CB8182A33AA956F85D
          D7F97C8F3EB870B5107FDFF44F66758B00867506904A326F88FD4024C445E165
          8B14EA9A16D435B681133A84CE8C66943763CFB87623664AF20A44D4E6DDD1BD
          F1FCD9330484AD67566C132A09A2D510E06712AFF77C3C10B62410E54F9A7566
          ED9D725CFB48B5EDAA7F2E98BD9A01F6376D5A4E0F3771A8397A2A24983A3F02
          CD2DBCAF2B01DC3604B8413272C982E998FC8E0F3FE54267FA8EB98E23E78429
          EF301BA2B65A1DA8BBAD1296BDE4581C118B7BE58F989D3F01FC6008709F64D0
          BA958BE0E23E1A2DADBAD1EB47AEAFBF0ED4555D98213B4B53D8F431C686F86F
          7096B281CA4602883504282571F8E2D3080C1CECC4EF667D6778D5B118A8BEBE
          1E05D7AFE062EE1954569443A13483ED60078C9BE40D3B0767488D8CF8F656BD
          E518D4CF04DF2665E05FFF39C1EC0E13408021C06592315BD62D83ABAB1BA592
          563702BC9A6A216A6B6B10B53214370B6E40695C8791C3FB61984B5F3C5637E0
          7A7E158AEED440653B04414BC2312F2018032CE4E8DDC30859672F61F38EFDCC
          EE2601B81B029C24F1FD247231268E1FC3A7180473D1F49FCF39834D1B56C354
          A6C6AE2FBC61EBE48C06892D1AA53630D6D640C93D80ACA90C9F6DCDC5FEA412
          7879FB2071CF1ED8D8D8A0A4B41C21AB3E67DD36B3D352C80401209924303234
          00D37C3CF95CE77404FACD989D7512111F2F45D8227BAC08F7C203E320BC90BA
          BD76221A73D518D49A8CE22BA7F15178269C5DC6E0F4E9D3686CD2605A40A4D0
          CC85008AC5000924E1211FCEC4FC99D36809DAF4C6C28E9EE9E703DBFE55D8BA
          63294A8CC2691F28BB3A955157DF8407C5D91854BB17FE8B8E23262606D1D1D1
          98B7742D7E7F5ACD9ACC2580A36200B62BD707CDF5C5D2A059FC1E1000D88FC4
          3D09D8B97D03CE6706E1A1C5063449FAE34DA5A6B60189074FE1C3494F71EEFB
          2F919D538B9C9C1C241CC8C0E51B45ACC90602D824066073B363E6344F448605
          D259CE8900384CF59982F7E94B3133240A95B219E8AE3C7B5E877D293FC3D444
          8678DF74B88DFD1671717130EBE780C3E9D9AC490A01048A0116927C3FC56334
          3E8D0AE53F26C2E8998E7077C1CE2DC3D06B7C3CEAA50EDD02543D798103A967
          F87AB8D73D442C8CC19C791FC177FA0788FBFADFEC7101018C10037890E40E71
          B0C5DEEDEBD0DACAA1DD1FD535D518EEE68C6B67E7A2A4D757D04A8CBB05F8ED
          DE631C3D7989AF8F776A42614A34CC2CC6E1938D9BF197A87FB0C79AF64C6813
          00AC491E999B29713C69BBFE2C6725BFA0009E93C6A2ECD672E4196F8344D2FD
          1DE6725E29CEFC7A93AF4F18DA8A87273642FD7C208EA61D1367C25002B823BE
          0FB01B83F244F20E28950A5D0AB219A8AE86FB3037A4277941E3BC9D36A055B7
          0019595771BBB482AF7BBBD6E0F096D57076F3424A4A0AFCFFBC8E96E8397B35
          8700D2C4000CD96D1F2D8193BDADBE3306E1E3ED85C05946F8D39C4D78261BF7
          46F3FB154F7038E317FDEFCB3D0B31DF2F06917F5D85F8F878AC8E4DC0C56BFC
          EC4413C0676200762199BE694D18264F1885F615E037C9F2E5CB515A7C1CFBBF
          5B825BF235F44EFE9A315BB2C2E207C8CAC9435B9BEE24B530036658EC4570D8
          09A4A5A561D6AC59D87DE0080EA5F1B7A364020812037C49B272D9E239089C3D
          B543E7E7CE9D839F9F1FB6C64EC03B1F84A342365BFFAEB1B11905649C77AB8C
          CF7FA1B0ADB2DEF614AEFF9081CD571B91979707954A8513D9BF0A99904F0023
          C5002B4876B2B360D5B205AF8D90CD42D2C1EF90756C0E7A3A4EC7A5DF27E3DA
          AD4A14DFADD48F5828522910274DC5A8583AE11546785745F746274FA4A7A723
          F7523EA2E31259B326B6E7C400EF91FC3876942BB6C5447432C51CFCFDFDF1D3
          4F19885D3B1193A7FB22BDC81D574ADAD0DAA65B305363092638D6C3C3EA323C
          2F9A437AE808305B81567B3338ADBD82A9338211181C4A7703FE62FC9266A087
          18C085A44835C012C9BB63D159D1683408090941666626DD948DE0EB3D186EAE
          56B077B04465950677EF54203FFF310EA7DDC1142B13A4C584C2F86D47FA9225
          A341CE61F0DFAEC1D26E2CFAA898154A09C0490C60CAA88C8C6492ECD4AF691A
          A55DEEF4DBB76FF31F97C2C242A8D56AD4D5D5F1EDADADADF97576707482BAEA
          09F2AE9E45D1D9CF61654E699D9504B5B405F69179B075F180A5CAE96302D8DD
          E154210896BC36A9FBB6C0AADF5BE8AED437BC44EE85CBC8CCCAD65DD3618A87
          8F9E40D3ACFB0FECE16F37A02ECBC7C5F4288C701C089C3A88C4123556ECAAB8
          D0A2699C28649918807D29BCD74404C3CF7B6287F57F5CF514A5651528BD5F81
          BBF72BF93A7BD64529A72860515A70DE545D5E1C70E49B309BF7873FC657A977
          10B5ADE810BD5BD01940384982B19C0E9D112EBC31FB97AAECE1234A374DA793
          40512898B547214DED0B8376C329765058B7C3B18C2BED0CC088846DD160964D
          A2572CCFEE1A18B12823330E7FA074FA652190BE242C2DE5ED46EC22F9F28F18
          7555FE0BAD892650D83CBDC50000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage13'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000086D4944415478DA
          AD97095454E715C7FFB3BC196677181C76501834E420A9D21A5B314B133D890D
          1A415123C6BAA256454F34DAA8B149C5A5466DB42EA16D1A776DD45409E680A2
          A8ECBB22888A882C033AC3223320033343EF9B0102385A9A93EF9C3FF7F1BEE5
          FEE67EDB7D1C0CA08C9B14ED4D660AC948D29132AE9FFF4A3F90BEFFAB7006E0
          7C3E990324A6D7EB4E5221E95297AE13D0D39F1D809CCBC894935CA222DEC1A8
          E0E178DA66C2DDF22ADCBD5F89D27B15687C62609B9A48E9BD807208A8F3E700
          D844E64FA1AFBE8235310B71BFCE048BB5134E0C072E72062A290F77EE95E34A
          6A1EAE66E4A3BEB1B9BB6B2DE93FA4EF482904D3F17F0390736732150C9F2FDB
          BFF353688D4E36E75656F4DB587592E4222E54328291715153F910D70824253D
          1F0D4D3D308DA4EFBB601209A675A0002BC9EC8E9AFA0E7EF3FA0434B55AC861
          273AADACF3BE10DD501C1A4D29E5432DE7A1FE5115AE675064D20B7AC3B0CE37
          11C4170301B82160F8C127FFBE0D0F1B3836A736675DCEBB9FED40E8556F0762
          0B0BE3AEE4A3BEAE1217AF66E3FB8B695467ED343D350ECBB974BCECB900E47C
          2499FC096FBC8A45F3A2F0A8A9A3CB693FE7BD9EADFDDF75458545918B78181D
          20C51F63F7232DFB264A7292C2EB6B1F9CA72ACBF300F69059BE6FDB6A489DBD
          61325BFB38D3EB1AA15429FB00F587EB0DEC4C9108F211236AE9265454690DE9
          095F4775765A53C84733C781730119ED106F7755DCEE8DA86DE8A0C567414141
          299293325078ED0AD41D2568F19C80D51B96C1C7D7D361347AA0688AFCDD6801
          9B9A316DC127786A7C92927BF9E42EF291443239028820737AF1EC2934BF42C4
          C7A7A232FF125E73ABC0A4C0068CF136804BBD4AF522ACBC10009F371760F1F2
          591049447D20BA9FD94918E123C1F9C4ABD875F0041E57DFDB7927FFF205AAB8
          EC680D70870645E4B63E6919192CABC3BB9AC736A7FECE6DCF3D2B4EDF522136
          67143E5C1183B0F7DFB2CD7977F8590019CDBF974A80359FED4566DE2D6BE1B5
          B3B38D4FF437A859F1330042C9EB3343BD6A8FEF9BFC10C355260CB4B4B4F310
          9BE28514D3046CF83C062FBDACE901705332E0C18CB0A88F60341A6E67251E5E
          4B5D3261BF53FA0248556F27ADFB55C67817713BFC550CDED6B40E18822D77EB
          455811EF07B7D039D8BA3D86A68A03B582416A7621D66F398826BDF648517AFC
          096A9AC806EA190085EB849A2DBF4EF15038B5DB42D96C9261D16803F8DC8143
          34313E9872D81F97F393E960B20FBF7DEF11245C4AC3FDA2B418ED835B19F42A
          A7BB7D0F002D3E69F9EDBAC637E439FC7703B43D03EADA9D1016D4017F89E585
          8E9B078742FFCA5AD4A87F873F2FDB88732736422412DAA662CAEFD74257DF50
          9F9EF0CFB9D4949DFF4A4700912D46D3A9868A468CF6CE42987B5D4F651B8F2E
          1F5F1E262BCC7D9C5AB90C4CC3664017F0071845BE100E72432B5D3B67BE3A88
          663ABCB66C8EC6832A2DA2576F438BA12131FFCAB7FBA8DB4576484700FFE671
          B9D3C416092E880E21886FC5127E2314EDD61E878D6A272CF430832390431F10
          0D9DF77430620544023E1891145CB10CE5777291B063038EA75AB0724D34E483
          C538742A01B51525B16537AFB37BFF5AEF1FC1E9722E62A31DFC7280E440DC69
          58A7DA7608E4CD022C961810DCD2DED34114B21052E11830BA3A28667E40DB8C
          818B8B1459771270F4CA169C63EA80278361FA9B0BD62EF910D54D8F50F6A0CA
          9C9B7CF283B6D6E6221AA2D411009B6E9D5D153D031F7F7410652329A790D99D
          723A7898480B36B2AD193C5A9982E93F40B97307F8D45374F81B64949DC0B11B
          7B91276C03C311E03D9F4844042CC5A2314B117F7E3B36ED8C83A9ADA5303BE9
          E8A7345C2AECD7F3330047C9CC3AFBAFED38752A192BB6C5C2FA5A0520FE318F
          F03708B04ECC8134FC1C9873C750DE7A137F09B90B3D63855AA8C692118B10E1
          350D6289876D1D4CFDED6C84878F455A61211A1F57FDE356E685D3B01FBF7D32
          254ED7D9AF0B7AC94FBE7FFBC7B69729570B3073C106D40DA3B4CFCBD0D358DC
          22C02F02835128BA89A7020E0207056349603426BA8EA375C0C049E68CF64E2E
          F494A64DFF6C2A8A0F19E0E5A386A9B564B1AEFA5E360D51D07FF7B00013C926
          2C9D1B8119EF8FFF71FBE99A3067DE66FC50130F84D0BC72EDE05CF031F69793
          3033680E46C9032013F3A19038D98E5C6D7D13F67D770807E2BE45A068042C14
          1D8552589B99F84D3475CD23691D01D8F2BE2F37AFC2C811C3FB54B27BF88B5D
          27F0C997BB611E47B9A9D43E2571E1F118AAF623A702C8C50CAAAA2B71E0E4D7
          387F2A1361A16F61E58A48DA153CDBFD4FE77E7CC1D53371B09F7E1D8E00D693
          DDFCE6D81044CF99020F5797670E99CCAC6244CE598F2A9F3C0835661C9F9D0D
          89138392E2621C3E760865B95ACC9F1D86E5CBA6C2DFCFD3D667C7BEA3884F4A
          45F5FD1B9F3E28CE4C863D6B8623004FABD592C5E5F26C3DFD877861B8C607C3
          FC7C6C5643FF0B8502343519317FD156A41AB3303E64062E9FB90027DA21ACD3
          F973DF835C2EE913B9F079EBA0D737B665251D99D5D1DEC69E7EF71D02B07F86
          048E0E19ECE9BF87118A87F3787C55EF065CBAFC7DBDDC31CC9F8048F939F790
          9E568498E591983C2994EA9FBD28F26E9662D5C6BFA2ADD59045B95F2CBBAE49
          86E70274D960928F42E5A174F1F0D348142A8D93481AC008441A2E8F37A84F27
          BA64BC3DD41421DF9E4805F879432216C16CB660FDD683C8C82D825E5BBEE776
          EE4536F74BC6734AFF84C495A424B10E1524768B42A9F67651B90D2528E700A1
          48AA61044E1A9A3259FFC1BCDCD5E8309BF148D74020ED35D949C79659CCED6C
          E88B060AD0BF88BB4006F582B27D23BAB80F757576F5D588654A1B14DF06C565
          DB531E68315697DD887D589AC39EE969A4869F0AE0A848FA01B1E2B3F332D853
          E32E912955BA9AB2F296E68616D83FD1725F34D84F017034467F28F672633FDF
          4B48ED2FEAFC5F7EDDC54E2DB10F0C0000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage29'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000006564944415478DA
          C5970B4C154714867F2E700589A151A084F25049A1444509A0E5A5D2A260110A
          E2032D98F05220D46035521A5EBDDA9298541445E02A886004C550DE45B1348A
          600D089452A1680511B1282A571E22CF9E591673E11604ABE949BE64777676CF
          3F33E79C9995C3F46D0EF13161CD634618116D33F8868CC9BDE6B921E143D811
          C684BC9C9C1CCCCCCCD0D4D4848E8E8E486A13BD6D0142C295F02756B3061515
          15D8D9D9C1C9C9098E8E8ED0D4D4848F8F0F929393D9E8B58991B725808D6627
          A1A1A3A383F5EBD7734E6D6D6DA1A4A4C475904824505555C5993367E0E9E909
          5E6C0E319778F25F05542C59B2C42C2D2D0D4B972E7DD5D8D2D282DCDC5CE4E4
          E4E0CA952B282D2D85B6B63607D9737ED698C26A2282C87F5301897A7A7A3B9A
          9B9BB99B03070E202B2B0BD5D5D5E33A05050521343414C6C6C6DC6CA8A9A9C1
          C0C09066A713858585C34343437BA95BCC9B08F02692DADBDBA1A1A1019A0DD4
          D5D58DEBA0A5A5050B0B0B0C0E0EA2A6A606ADADAD484848E4628299BFBF3F52
          524EA1BFBFFF28DD0613C33311B098F83D3F3F9F0B362F2F2FFA580A84422117
          0FCCE9E5CB97D1DBDBFBEA056565657878782026E63066CF9ECDB5858484E0D8
          B1A378F1E24500DD26CC448080E88E8C8C548E8A8A42444404EAEBEB515B5B8B
          C6C6469997DDDDDD111B1BCB2DC108E5014BD131B3B75F8BE2E2E24774B980E8
          9D8E00E6FC20B1C7D4D41456565658B56A35E2E38F73A39636B6F6229108CECE
          CEAFDA260AA014C5CE9D3B40F11045B7DF4E474006B1C5C4C404478EC4C2DADA
          9A6BA40F402C16A3A7A71BF2F2F230323282838383CC87260A60EFAD58B11C55
          555595746BFE3A016CF43D3636364A6CBD0D0D0DB93555545494723002B949EA
          E644E763E6EAEAC252F7215DB29C7E3C95800F89C6438762101C1C8CBCBC3C64
          6666223535755201237CEDAB2A2F47F3DDBB701B2D4AE36CDBB6ADC8C8C818C4
          6870FF39950056CDB2AE5D2B83A5A525D790949484CECE67D8B367EF64B387F3
          274F209B82D086AAA544208FAFF7EF1FF79C65D1E9D3292C0D57109553090857
          5050104924CFB9B41AB3C0C0001C3F1E3FA9801FC2C270E1FBEF20983307D1D9
          D95869FBC9B8E72E2E9FB30ACA96C08DB83E95808C65CB966DA9AA1A5FF1A8AA
          415D5D0DE6E6CBFF55C0F0F030AA2A2BA1419B93AEAEAECC73168415151537E9
          3288F8752A01757E7E7E8B1213C5321D58C98D8E8EC64CACADAD0DFBF6EDA3D1
          E7A0BBBB3B8F9ABE613E2613C042BD472C3EA1E8EBEB2BD361FB764F0AC6B469
          39EEEBEB43787838AE965F4743FD2D74510C91B1202C265869BE8809A5990958
          C4D45557D78CDB01C7CCDBDB8B8ACAA9291DB30C898B8BC38FB97970F4DD05AB
          B58E282F2EC4607F3F7E3A9F86B24B051878F992756D25528864A2694C800E71
          272C2C4C2812ED97F9B88F8F376544F2A4CE8B8A8A10979000B3CF36C261B307
          1EDEBF8792EC4C58D8ADC342A345E827C78F1EDC476569098ACEA5A1F6461913
          CC92B884F86A2C06C40281C02F3B3B87DB74A46DEB5677A4A767C8382E282840
          0AD589F9A69670F3DB851B2597F0F4713B152F21D6B8B9737D9E753C464EEA09
          583B3841DF68310AD34FE368C45E489E3EE9A3C761C4A13101F399222AB50BD8
          2CB00062659799B3B31305531E773D30304062D27181CE08FAE636D81CB01B43
          B44396E45E80AEBE018C4CCCB87E8FDA1EA0EC623EE41514E0E4E18DFAEA0A1C
          0AD9853F6EDE608F6F118709969E1DD2F5732D71922D094BA9A0A02FC182D2CD
          6D03090AE11C575656A0A1A101F30D8CE01EB81BF69BBEA0EA28E046AAA1F501
          4D752B6E5EFB85FB989DEB1674499E215E148A82B3296CDAFBA99945333BBEB1
          25E8246AA405B023153BFDEE201C0901DBDFD94CD0BECE9D05C886305A520D08
          85F7D4D4E1E613880DDE0198ABFE3E7EA6B5FFD465130669A6CE8B63917C5084
          9E2E7662E3DE6127A4077C16B0FBBB4CC8C41D849D282C78072B0953429E8FDE
          06E22A2121D4888DC41A42A8386B16EC376E833B2D49C7DF6D88090DC6BDDB0D
          DCAA1167892CDE311BF56F4497741A4E3405E223426F92E75DFC87B408756203
          B10EA3075369BBC38FBA8577CE4E347F61C2117EAA1F131542939847F4F38ED9
          96FA9C7F3E8BD0E785CE9312C206708EC8E4978CCD588DF4A8A72B60BA269412
          C2FE0D5489FBFCA86FF33331E98FCBDB10202D64214653BA67AA51BF2B0163C6
          F696414CF377ED5D089891FDEF02FE01B5FE49B2FAB01BF60000000049454E44
          AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage28'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000070D4944415478DA
          C5570B5494D516FE6686D219E59581178DE552F08150A020240FBB6A99F9B88A
          D2C3019F09B2EADA25D254BCDE7C04CAAA4C436FE42B10F4BAB8B804135A8416
          A4808150E8DC860B1286D7C206189481190786B97BFFFC33890A4ACB567BAD0F
          E69CB3FF73BEBDFFBDF7D9BF04FD135742B0087FC27384967EEED14324F7591F
          4C7889F0AC78281380A3A3238C4623DADADAFE4AC3BDBF07016F4234219C60CB
          1363C78EC5DCB9730504050521222202C78E1DABE6A587496009E13542808D8D
          0D424242AC87BABBBBF750DCB76F1F56AD5AC53FA710CE3E2C0297DCDCDCBCE2
          E3E33173E64CD8DBDB0B931D1D1D282C2C447676B680BCBC3C30C13163C6F072
          1DE1266138E12B4222A1FCB7124821572FADAAAA1206191919C8CACA426E6E2E
          6EDCB861558A8B8BC3E6CD9BE1E2E282E6E666B8BABA0A64DADBDB515C5CAC27
          152521EBB710785D2291ECD16AB582F5ECF6DADADA1E0A32994C7835C3870F47
          7D7D3DAAABAB919E9E8EE9D39FC5AD5BB71016B6103939395DA4FA37C29EFE12
          F023949D3E7D9A369C8E458B1671A0090B0101018295172E5C805AADEEF110EB
          66679F8442A180C9644278B812999999E8EAEA5A40CB27FA43E051826EFBF6ED
          8FAC5FBF1E090909EC52180C06141414089BF760EBE787E4E4648C1A350A67CE
          7C09F6DCD4A9533172E4483CF3CC141415155D26B57104D383125849480E0C0C
          94F14672B982DC9B064B4C5884EBC09A356BA0D16870EEDC59984D8D18356200
          05A6142AF50D188C83E1E0E080B2B23256E7ACFAF84108EC20ACF3F6F6466464
          24A558B4F0BE39F8DE79E71FD0E974C2D8C3C303C1C1C1888D8DC5409BABD895
          380B8A6113D126E11A2585C27C15C6A68B88FB7B0E72BEA8E782C55E18FD2004
          6E7A7A7ADA727A85878793856BEF50350B7FF57A3D264C9880A52F3B4319158E
          3AA9129D12BB1E9A3668C7507D068A4E1DC5AA987C93D98C17683ABF2F022308
          571212B60BAE4D4C4C4453531376EEDCF9EBF1B48B84B4D9F2CBEA93F8E8C006
          5C96ADEC35B82ABFBF025B63294AFFB50D87D254FC2E82081DBD119845C8C9CF
          EF8E7E968D1B37C2CBCB933241695566527E7E3EC8CB5E809F9DE369B7C1BD12
          28BF588BD3E72E61DD0C3594A1DBD0D8A47F83A6937A23F036E57F6273B3D65A
          FD585E7D75050E1E3C641D9F3871023BE25FC3D1ACF750671381BEE49B6F6B50
          50F21FF853B1FC2E2D169FE7D7BD4FD36B7B23904A1570895ADD33DA0F1F4EC5
          E4C993317AB4507241E989FACBC710BD6D0F34D2903E09B0F5EC05F9A3527869
          E3B1E3C3D2149A5EDE1B81F2C58B174F4C4D3DDC6391F37ECB962DD8BA75AB30
          5EBB960C301640B9EE9F68924EEA9340664E096A7FBC0EC54019FC0D89D8F46E
          D1499A9E772F0252826EF7EE8FE4AB57AFBE6BA365CB9622252555F8CD2537F5
          E046EC4DFF00F5B2B05E0F6F6ED1212DB390EA41079CEC243015BF8D7F675567
          D0D2CBF722C0F76C4D49C979A1DCDE29CB972FC3A79FA608BF3905FD273D89DC
          CF22503D7013CC12D95DFAAD6D7AA41FFF1A37757A611CEADB8C0F63DF426D5D
          0BE77101E120E138C16021C02F589D9CFC89342A2AEAAE0D23235762FFFE03D6
          F19C397330DEED3A96AFDB8C6BD2D9D679BDC1888BEA7A945FAA45AB78B86280
          044B6C0FE0C5985398FA973054969C45B3E63A2F711B7784B0CB12039972B97C
          61717109B812DE2E7CB11C3972F4D7E0A28B6AC50AF2CADE600C9D1889728D0F
          BE555D4155ED358A992EABDE60B914076AB6E1F1F40A6C993404951E6198B170
          11362C598096A646F64632879585800FE18C9D9DDD63ECEED0D050EB46F3E7CF
          A39E20DB3AAEACAC4474743454AAEFB0E14D5F04CC51E2946A04D4573BE9F603
          EC07491032BA0563B4A7F042097573C6F3304F1982A0DD2A94A8B4BCC52F84DD
          840AC24FB79762EEFFB8C1B49F366D1A6262DEC4ECD9B3F1FCF333281DD39094
          94245C3C151515F0F07B1A5EBE0128FBFA4B98753508F41F06EF279D20934A50
          A9D2A0ACA201DFD7E8F0EEB461883D9404C9F9FD30356AE01E57D679A5C1C096
          E7893170F176025CD0F9FEE68A358127B821696D6D155A32EE7C44E1D648A856
          E37CFCE0EEF9144C9D1D686CF8190DFFAB874F6008DCC73F85818A4148DAF416
          7CC7CA919F9D8C474AD3D1DED400A7D78BB5ED862E3696EF86CE3BAF634702A7
          02D7ED3F8B446C08D7085562147337E2457805DDDD339C873D8117A35663FED2
          2868C9D25D713128CECFB5EC59EDE66AEB52F1D5C7B6763FA4C0E78DD2AECAAA
          9BB3442FDCB32D1F241EE084EE1A6186E52AEC964ECE3691AC07BA73DB9717E4
          64752779A383BE1948D865DC92F145E4EB683740E93CC4C6E9BF756D17683C93
          D0D51B018B3C4E70118918C5433504CE23EE701CC4147616FFB3472CE5B190F0
          89F8CC2D7ED7E2730EB8E34BEA7E5F460F22F62281A10437C263A2D5105F9D0A
          F7B8861F26018BD88944FE245A7D89D070BF871E26018BF0A79CA12FAB7F6F02
          FD923F9CC0FF018FC99BB2C24420600000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage12'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000009194944415478DA
          AD970950944716C7FF73CF0003C87D5F33C3A5E562341E1B7535285A226224AE
          46118F326A24586C44C5FB488CACB75296F15624ABC455A3968A28821A0405C4
          03E49653B9191944846166F67D1F321B095E55BEAA3FDD4D777FEFF7BD7E5F77
          0F07EFB16113E68FA4622C49452A255DBF757E5FD5FBE67DA871DEE37C2D15EB
          98BA4828405BBBBAAB2B9B74EDB56E10D08B4F0E40CE2DA97862696E6AB47BE3
          6298999B43D9D484B2B24AE41795E176FA23E45149C650A5911248BF134CF6A7
          02D84145F88AF03930B1F342E30B0DB45A1D84020E2C8D05ACB46D2AA4DCB987
          E494CC2E18C60A4967496748770948F7C10023478E94797878AC168A44067915
          AD13DC646EA2B0B030D43C57837C778AFEE8EB3A1D8C253C58100C57DD8CACFB
          F7BBC33C63A242DA492085EF04E8DFBFBF60C08001656471AD1ABEBB8B83D5B8
          80C020387A0F47557D3D4A2A2BC1E3F2606F6D875EA6A62C00F987862A3A2D95
          5417F2006B532104DA1682C942524A062D5739F3F852923B41A8DF0AE0EBEBEB
          EEE4E474EBC89123D614FE2C2B639E8FA7AB0582662FD53B53B777A0F4D933D4
          36368089AB4820848BBD132412C95F22D4CB888FCFDC0CB17EF33EDC48CBD296
          E7670A48DAB7020406060E96CBE5371A954D59A50DBA41215327E08F6B17F0C3
          BADDB02C0A0147A781CA74225E48FDD0C195B24E5EB6B6A2B8BC02AA961616C8
          C4480A273B07F078028A1630D4CB18A1915B909D57CCB8A8E2E874876F5ED8BF
          EA2F00A3468D32A1B72FA5F09FD44030D6D1DEC665CAD429789CFF0493828260
          7BCF9D003AA3A7B45D0AA5DD3276FDB55A26323A7D8494AA2602AAA4CFB51DBD
          DDEC31C8D30601C18BE1EDEE8AEABA46D43528D1D1DEF6CFD4F8A3A7DE00A0E4
          FB4226931DCCAFE5F93089D3C7D5CCCCD1C604C173C321A88A854971989EB8A6
          6F2AD4128FD74E75ACE3AE84D4FD292F14B662A4676661DD968358BD2C0C4642
          2D96FDB807D51505EB0BB39236D1A3DAF400D3A64D9B61676777E879734B76C1
          B3F67E4B177E83C4AB97B074F526B4DD1A0B2B4D1AEBFC95508EE681E96CD231
          8BC900A8351A7039BCD7209D105C7AAABBBD043F6D3F8C9B690F70F2E016C45F
          4DC2BE98B3C84D4F985B5F55729EA6D7B100F4F6DE0A8522A5B0B0F028F8E229
          1E0A99EDE4AF27A1E2690DFCC78D86C12D570A7F070B50691A8AB4D6496CA219
          88C5F094B9E078F606B477B4A28FF5DFD1D76638CC25B690D2A7696EC443E0CC
          253035B740ECAEE5085BB10D99F7732A522F1F09A54725939A5900CAFE79947C
          018FABF03543E5E560201D32D0075F4D9E0EEED358F073BED387FF95451CF8BF
          5D86DAD71F4D3E9F23BDA408BF962E6762C1F607FB8461BC7710847C0EE54F31
          25E056CC9F331D137CFB236046049A1A6ACEDCBF75E6171A7A559F0314817E94
          800925B5EA489D407A303860089A558D58B07011381941E0D427B0037546BD81
          547F70A237774EB4B543E2897F63FFDD5DAF938983192E1B20159BC06FB00F1B
          EE5F4F5FC1C90351789C57880DDB0EA1BC207345595EC6251AFEA07B124ED688
          6D67199BD98C0B0D1E0323A9146656A670CE19082E34EC4081D75A74CC3E015D
          5101DBE64D9E8635FE22E4D63E62DB3E7603B0DE6FBB3E5A21DFAF0787CBC7B1
          DD2B59E709C9775EA65D3E365DA3696712AAFA0D00DA78F8943DB5E3FD86F68A
          5818CCEE6ADAF258681FCCD73FF07E53147C9644EADBADFB0F60CEF3FD14FCCE
          F07FFFC5328C56F8B3F5AA9A7A4C99B70AB3A6F8632669424804EA6AAA53D213
          4F30D91F4FD27407184D45C296B561F8DCC79BED50DFA164ABB9C2D6B9267DC1
          BDEB8F8E6D9BD8768758823D3B1623B539BE331AF4A63153CFD1A72665DBA72F
          2661D7FE38ECDB1A89B6B6762C5AB91D754F8B76E66526C6A1F3E4447780BD46
          869205E763B682C7A70D5DDD8457979D280C9D9B8FC07B3D3AE650F80BF23A1D
          7E351991E305286EE85C0E47032F8CB5FD167D644E70B1B34204ED9E054F2A70
          EED866EC3D760627CF5ED5DD4F3917D2DC509D42C34BDE0020E75C66F3F11B31
          C87AD5BF66D35E5F8B82822CC8DB6260DD71934EB906089D7F47FB9889FA492F
          A277636E6B8CBE1D3E6C2546CAC6B0F597ADAF68F78B80EFB00158113E0BC1A1
          EB505C5C5A9076E5580475273243BA030CA3F2E6C6E50B306CB08FBEA34DADC6
          A38212BCAC4985AE9C0FCF1307217D900E8E50848BA736E1786E6C677468DF8F
          997A1E060243B67D33350BABA2F661FDD26FE1EEE6846F16AC465363D57F1EFE
          71FE207527A19B31009B783C6E64FC899D108984789B29552F90939E056ECE23
          245BF391DB9C0215AF04839D8761F9971BF5E3A2A26370E57A1A2EC46EC3E5C4
          DB883E740A4F1EA7FDF0B4E80193508F7B02382E140A824F1DD848E7BC313ED4
          4A68A9921FDE65D3C8EFB321B0B73263B7E6893397C2C9C106D13F2F46F8EA1D
          48CFCA51DEBE7868160DBC4DAAEF09602A9527246211860EFA1BFA7ACBE12173
          869B8B1D5DBF041F0CC4586E6129E6474461C1CC49081C3B9C3D0955CF1BAE65
          26C5311B0413819EEF0304114A9FF3066A997575D0B2C0C5D10E1E7227762DDD
          29C3E5AE0E10BF6399F61CFE2FE2CE5DC3B1E83528ADA8C2DACD07505D961F55
          F820F9347567F434477F21191E30CF4FC7E15CF9C7907E70B4B746417139F249
          4DAAFFDFB8B974CC39D9DBB0308C3C480A5747181888F19CC64DFF6E0D8C0C0D
          10B7FF276CDC7904F1D7D33419D74F4D7FD5A264C25FF14E8011236689D586FC
          0C2E8FD7DBC4D808FDFB7AB24EACCC4DD141476E399D8ECC759C815235B7BCF1
          1007FAF61B952AF6138C5C1482B15F0E4160C812D4D6D63CBC9B10CBDC809803
          A5ED9D008CB978F57336B396EF15490CBD787CA123874307FD6BB3B132D72F87
          054169345A543EAB6181988BA748244080DF5076FBBD732F87BD7C34D6551CCE
          49BD7494A6DF7ADBB2F5F4BBC095D447283112DA38B8BB49CDAD14124313B940
          2891F3F942071055D7404BF35E14254736520A02F3943B834FB9B3E2E75FF028
          B7489B9791B8A0BEAAF8060D2DF81800C6C4241392E96B317591D8D05862EDE8
          2E3336B5928B0C8D1542918182C717D8FC792297CBA50B8B162F9B955732937E
          DB43FFBA496AFA5880B74199E24D28A1A1B18591A5A34C2635B152880CA40A01
          5F60D9ACAC4D2ECA4E4978D5A2627E98A4BCEBA11F03D09349BA013165D7E6C1
          646AE6BBDEFE5300F46406241149F92183FF077A5DC34E167B70C70000000049
          454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage11'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000007B74944415478DA
          B5970B5094D715C7FFBB0BBB0BB280592510DE0BA41A9B36A63CD24C82047C90
          7186803C1A2190228E806946A2EE4C1510124523A891204E68ADD66948B49616
          9BF82099680C8651868288918E288F80C684F71B79ECF69CEFFB205BBAEB98CE
          70677EC3B2DFB9F7FEEFB9E7F1AD0C96C753C40F4417E670C82C7CBF8CF83B61
          203288D2FF636D35B181F88AB8F65304BC449C767373D3F8F9F9E1E2C58BFCDD
          79228D687B848D95C47A62BB5C2E7735180C5FD3E7484B9E9C2D2084F8A78787
          87A6B4B4145AAD16274F9EC4FEFDFB313434344CCFB288F725CFCC1ED64432DB
          68341AF78484042C5BB60C898989989C9C7C87BE67A61E26E045E2536F6F6FFB
          53A74EC1CBD313FD0303E8E9E9417B7B3B76EDDA85DADA5AB6AB261288DBD23C
          2B2289C8B6B5B5F55ABB762D2223235930ECECEC505C5C8CF3E7CF7F4FCF9713
          372C095840BC461CA08D641B366CC0E8E828FAFAFAD0DFDF8F0182DC89B3E7CE
          090B1A8DC64D9227785C51ABD541717171888989C1E0E020E87F0116BF71E346
          FEAE8AECF289CF885173021612CF1119E4FED013274EC0DEDE5ED89805F411BC
          30794738DDF0F0F036B27D579ADB419BB8AE58B14210CDD746F72ECC4B4F4F47
          6F6FEF3FC8E61831C6628961D32B34BD8240621151929292A25EB76E1D6F847E
          F2C2006DEEE2E222B874CD9A35E8EAEAE2FBCC91E67D471B392F5FBE5C10CD9B
          B3FBD3D2D20C9D9D9D1FD0F373D2E6BEC41BC42EE2A43901F3A4208C552A95AF
          1F3F7E1C74A7E825372E747202059660141F1F8F8E8E8E7DF4512FCDEB4C4D4D
          5DC01E707070C0F8F8381A1B1BB175EBD6717AB685F8251141F39D743A1DEAEB
          EB39905E259ACC65C16289E2A0A020670E3C5E707A731ED9D9D9B874E912A754
          18D140F452CC38B0004747478E0F585B5B23333313555555F0F5F5456C6C2CC2
          C2C2048F464545B197D269DE1FF82A660BE0880E2582894C7223A81EE0C18307
          98989810263B913778C19A9A9A5EB2B92593C982B2B2B2101C1C8C01CA1ABE06
          16CD73E8AAC0B5A4BBBB1B0A8502E459E4E4E4F05C0E46AE15EDE60A913BF10C
          B15372DFCCE04D4A4A4AA052A9C0E9565D5D0DBD5E8FE8E868E1796B6BAB700D
          BCD9D8D81846464660636323D8736C545454E0D0A1435C17381D371295964AF1
          0B84136107B1A4AA2531C9E1E1E1B2C2C242C1CD5C6C1A1A1A50545484458B16
          616A6A0ACDCDCDC29571FC70EAB227ACACAC90979787CACA4A5EFB0C71847840
          5CB02460FA3AA671E1F823B6CA64B08B8C8C427E7EBEB041525212EAEAEAB072
          E54AE1C48B172F46444484F08C4FDDD6D686EDDBB7E3FEFDFB9C0945107B03A7
          620D31F83001A6D9C1519FB6657D301C9DFCF0F6DE63581B9F80DCDC5CC12039
          3919AD555F83C4A16D624A08C6909010C1F5656565ECF26FC96C377197D396A8
          2726CD65C1ECC1C5E92FCF3FEBE9FBC9D1344C3A84A2FA4C012E7C5285F72AEE
          71AE43BFF92D746FD3C3B9E9261C7FF7160E16146047532BCF354AEB5F200E43
          AC05378916D30D2C09E0C692435EFCFDF18218457CE27AC86572A0761FDAAA7B
          70BD7D04455FDDC3E7FFEEC307A1C1706E6CC013D672E8423D207F66213EBE71
          0F6F1EBD415700EE847B2196DF7F71CACEDEC89C007E11F9F0057FEFA5E525AF
          43EB1743E14D95F4FA559A2E9A57770C21E6E82DB4770EA3DCC551586649D842
          F8BEEA0CB852EC7ABC89A3EF6720E5ED3A36E732CCAD7CDCDC4965B33E675006
          EDFEF3DE68753C45B85C4EF1778D7A4E0B796F4234EDB355E3D9ECAB68B937C0
          51AC7A57ABC192794AACD63F05193B5D4776EE94C9EE6938B0331D5BDE131AA0
          69E5342BC09E384DA70E292F4982F649AA942D25D43CC96BDDA2815101FCAD43
          81B8DD5F1AA448FE06620775A858ED8995E11E92A124C2834ABF5B0AB2F4C9C8
          FBD32D7EC2BDE31D4B02D2FD9F763B7CA5340267EF84A0B37B002FB94DC0BBE9
          23E1E1B0AD0AE1071B71B9E16E3BFD5B4870947949919CA39063FEED82407829
          553FAECC22BC96004F24E28DD4041CFEAB107BDC1B0E9813507D6CCFEA80DFAE
          B2475973341E9B3F1F7E774FC375B00E9FF728B12AFB0B3E35BF237E24DDE56D
          299D7E4DF8107B545632FB967D8170512831E30A1D05AECE1FC6C7A39198F01B
          949EEBE007A910FBC07F09B89A12E71F7864B30D26FB3C31DE3A04B9D520628E
          DCC6992B6D9CC3072176AF018839DC6F7275CF436CE3791A1B856D737E00BDDD
          58FF28C29744F8BC0883F665BC12198D4F2BBFE7C3244A879911B099D8BF3323
          14AB831CD1D3DC8F553BBEE0CA5A46DF7F4C4C48029AA45B361DF321D68B9FF3
          1D6B350AF59D3D8170305A494724731F12B17433C67EB88C15897FC4E5FA7EBE
          BA58A27C5A80428AD44D92A856E9D477A4535F93FE5A1A5A2288584AEC7071B4
          56DECA0B809D41316330E46A44F777E368A18C8A2ABE89BED149BECA9FCDAE03
          BF22BC21360AC3434E6D6E70F30A80F86695A97B5CA5F826C71FEA29B9581259
          8BF44E9C51D68CC22FB92AC3DD5C21B285580959E1E8236C6C3A5CA4437037D5
          2F719F27AFDDB614461B235443F219A380823AD47C3BC407543D4A33FAA9C30D
          E2FB04BF316DF2F7D1C88A5ED3E1B905F698983262F767EDC83D2BFCBEE10AF5
          F45C08E0E149FC82789948572A6478D2C91623D4299BBBB82709DEE5ABAA9F2B
          013C74045522BC42AC81982D1C0ED7895CA29C8DE652000F1FC91B36049749EE
          86FC563C5D47E65C80E93ECCFFFCA6FC0FB6B4C2860C8186430000000049454E
          44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage25'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000008624944415478DA
          AD970774945516C77F535267920CC98404A2812484E246DA4A91664810F0486F
          47C195A5E8BA1E71378BE22EB8822E5203CA5A6011384080A0447A7101E90722
          BD1A48055209A44CEA643265EFCC44481B17F6EC3BE79EFBDEF7CAFFFFEEBBEF
          BEFB2978823262C408A5A81091B62235BB77EF3EFB24F39B2B8AC700F50E0C0C
          3C1A1C1CDCCED3D353E7EDEDADD46AB55CBD72E5AEEEEBAFFBB8412BAB884D44
          166B85B31E28F5BDC276C33CB0FECF04E2C04B0BEDF2A74C391D1D1BABADDF77
          FDFA752A1312F0AC2AC7ABAA0CA50A0794D5C443C84B30670F244935F5B10808
          DBD61618271F8749B3A3C853662F37C5DD41431834761C6AB5FAE1588BC582CD
          6623232303FFEC1DB46B5185C9CD8B80201D3EE52676CD3B47111CFD0A96CBF0
          5322A5BF4AE0231829EA7B11558B702FF4511A6E68225085C512D9BE7D03F05F
          8AD96225253D97B3573330DB540FBF8F7FAE88FC453B3057593297C29FE453BA
          C84D970464E7BE62B57B4A95C273C08C8E7877F0E6E7423F922EB76250741FFC
          7C34949455515E69C464B66143859BBB075AAD069D9F0F2DECA2F3C147DA5B77
          1E222BED322D4F25919D5359FB03FC5D207E1439EF92C08710260E93A90FF365
          C0C79D597CA82DB9655A060DE8C1B39D22880C6F8B3E30905A9B9A4AA385CA1A
          2B5522B5169BE3182CF6B3171D1EE449D6AD2B7CFAD93A4A4F6FE6DDB76792B0
          6D1BC75352D608CC1B2E0908C52E52B91CDE2B480EA23B6B9343993B731A111D
          3B73BBB0869A5A6BA3190D9D47A170B642FCDD511A0B193D713A6F746DCBD809
          1348DFBD9B19DBB797A4E4E5759321775C1DC1008138DE75785BEEF7ECCCA673
          ADF8D7E79F70AFD2E3219442E1827DBD8ABF568D87299FBFFCBE2FB3FF18CB91
          5DA9BCD06128B357AE349E2C2A1A23430E34BB8638E0405147FA4DEDC8CDD04E
          245D0A62FDAA6514182C2EC1EC95C69CBC3D957C1A379AB50BC7A131A7713FF3
          183367E692909AB75DBABF15B16B737316E82E16B8D0777207D2DA3DCB819BA1
          ACFD721139C5A6A6041A98BE617BFB96350C0D3948DF98B190B6906B05CFF0E2
          94BD55F76AAD4BA43B59E4DFAE8E205C0864F498104151CF6E6C4A0E66DBFACF
          C82E323501563442FDA575ED523217BF9DC4E2458B047C01D5EE514C7AFF3086
          6443C911582643F6895C6E96C0DF204042EA83CE2FB781979E63C5413DFBB77E
          496E89B919876BB8804AAE4F45712E7193FB7370F37BA8F2B7CA95A825F14715
          73975F26AACA62D9056FCA06AFCBF0B3CD12100BA865406D87E810025FEFCD3F
          76EAD995B09CD26A5583918D89F878A95059AB191CD3977DAB27A157FC0CC5A7
          C93074A5DF5B07E9E5A3C43DB3D48E3C3D45AEB94C3BEAD291C511CBC37A0569
          3BFDB91FEF27EAD9B66601B54A6DB3833DDC14E8346A940A1B23478EE483DF85
          D1AF776731FD621E98DB33E9C364326BA3E8A2BE83DF853BE4C0DC83E2633275
          BF88CD15819C9028FF90FE0B62F8C39A00367EF1115EBE814D1C4F239EAEF574
          5A263E3E9EEF372CE4E8B60FF1CCFF0643859957E69710F5C2540E9CB8466FFD
          7D39F9F354C3EA2D20EF12C7442A5C11B8AC0BD17499BC6528A396E9899FF72E
          ED22DB4BA46B08EEE9A674D44B4A4AE8DBA7277B12977270EF4E5EEB7292D7E2
          6BE8D06B22313131CC5F9140B796A51836EEC74BC0570B0999764EE45EB30424
          1AEE51A995C3669F19CDCB8BFC99F1E6EB44F77F1EABD5E618E5E1F608DC5E66
          CD9A45764129D3863C4D4E663A6B771DE39529B3888888407207FEB97E2F0AC3
          35AAD67F47305CFC5C8E41A68993387CA12901E9FD4AA0DE9E7968386F6DD213
          FBE228268E1F2671DE2667ADC0DBE311784E4E0E83864F24B26B0C9E6557086D
          D396E88131B8BBBB1319194978783873977C43CAD55378246DA2658DB550DEE4
          693843F1355747F081A845D337C6127FFE2982C2A279EF9DC90E02F6DD2BEB5D
          8169D3A69391FD80987EDDE9D1A38703B875EBD6848686A2D1681C635627ECE4
          BB9DFB884C4EC43BAFD2B612C6543BCD7FC6158157456D19BFE4797697B5E39E
          AD2BCB3E8E735C37553D74B3D9CCC58B1731994CE8743A02020268D9B2252A95
          AAFEBAECFAE104CB566EE1B7397BB05CCCE3A45857A2509A741D76E5037DA571
          6A705C176E86FC8643A96124AE9ADFEC23647F82158A5F4F270F1C39C3C2151B
          E8537D14C3A154B261BE84C29F703E48962604E649FA25C128BBD7AB912807F7
          60E99E161C4EFAE2BF02352EB9F9F74949CB625DE25EF20A0A78497D9C3B49A9
          94C3BA4DB043869C10296B4260BC58BA1318251AAAA3E206F0CE5A5F766E5882
          BFCED7255849699980DD11B94D4A6A964397575439FA544A2BA33A67A3C8CCE4
          EEA6540C929C4A56B2016740CA6F42A0CE0F6E07776CD166FCEA218C89F773C4
          829EDD9E71F4551B6BB8957ED7B1BB9B75A0058545CE451456F41A13C1BED504
          FB543B7488AE9616BE2A2EACBCC1FDE47B64C09ACDE21A389265725D1138E1E5
          E7DEFFAFC747F1C9360DE7EEF813DEA6B5ECB49CBBB9058E98A09048EAAFADA1
          9503C848908F1DAC86003F356AC99CAAB22B28CB2AA3E89681BC1BC5D454D4DA
          97B6CA3B1CF7933306D89FE507AE08C83131694EF258CA4C6EAC3BE2C139F15B
          BDB69A20010BF631D2CACF88DE578D04458C79550EB0925403B9D78BA878606C
          E8AC7269E44BD60D48DCEF8C82F6F339DEAC13D611982F6ACED4750369D3DDF9
          0E186B2C64E755527CBB9C7291D2D452726567C5B2D3FACF8A542D0266FF9A56
          2C225E9F2EB6CE92BB5F53E7742538D373537DCCC60462451DD6B5D610D92F58
          CC67A630B38CC2B452AC165B7D309BAC922360E9763079EDD2042C53DAC63A30
          FB4F88A14E57D0E8057449C0DE9690BCCAE64CA11FF609587EA580C916D2C47B
          24EB27A3C469CEB27A4086BAB64BB0C721E02873E0E942987257921401CB92F8
          29D7D8218DC1AC8F0FF50404EA15FB0B64CF4AC4008F1CE7FF59FE03AC9D4A4E
          A63ADA640000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage21'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000004654944415478DA
          C597796C554514C6BF82808D528116C160205017401382FF4B0D4BC23F24A2C6
          840809206224848090F0970123681190024280101691A40A4665D104E2865614
          C2BE6917A8459AB2D845A43C0AAFE577EE0CE9F386F6DDF77809937C7D73E7CE
          9DF9CE3767CE39CDD27D6E5951273E25E575915E6E9646B7483D187A08DC884B
          BFF0BCB354FA95E7E68C1278868D98309655C7F3FB3CE8D88DF17C90070E825A
          3F1722E575D28C1A692F8FB7EE99009B4FE3670913B2BBD2990C5EF41BDF6966
          EE11B006EC7743B1ABD2F22A6911FDBAB409B0F94A5E4C4772BDE6377FA49D45
          62E023B0CD9BCECE0B2E481BE99E4D8B0012CFCEC6FA22FA23224A791D2C05DB
          C14DE94AB9F45693F45D3225EE4AA03B063F26550E91BA6D0D4DAAF156F6060F
          84BEFBC61338E854D951EE84F959ED38679B3ED05F2AC4CDE72EA30F119D0227
          41B55FCD3EFC20F4CD21F00538E0883633777A9D53A1346502DCB31CAC3CDE59
          EA8722760DF530A8F4405E7DAFFF3B6509D8ED491A997AA9E86F772B8CC48D94
          08587B1417C891E6E08CC399D839CBC97FB6A334C07CA32834DF9CD06EC5BFE0
          27704D2A3E27D929FE0E2EA74C80D601F4C3F2A19079A9513A431C189F2B0D34
          A97B254CACF7844C995AAF0604369F736E7102FC950E81C479BD9E94DE438D29
          1FF350109AF02938EDFB67000E68EEBF90EBF81BDD63E0FCBD10B0D850C8E4B9
          B3E94F0CBD3B0A3EF7FD5BADF2D79649539BDCD997A88DEB9894800FC79BE88E
          99C19F3742EF6DD5B572E76ECD7C00C75383B4E2BC73400B113FA88DAB988C40
          D6B3383D67DED72C1F137A59EDA5AFF7CF76C8C715E4854A8EC1F892A774D84F
          BDFB061114B8442CE8392A346E675C0C1AFDB3C5DCD3CECCEBB8FB3B97A43FBD
          4025ED5A988CC060E2CF2C784C4918DBE357BDE9AC0D3CEC82DBBC818DE75D91
          2ABCF5250902A5476010FB910547BD9F30562877E6385A1076AF3A2255E8BCB0
          C1C91DF7D25F4CB67E520203A50D84E249C50963ABBCC555DEFAFFA42D38DCF6
          B873340B050792591E99C0D3D27C52F1BC7D721E6E39A1C2AF4E44D48F4E81F5
          38E0D772B9CA5CA131D9BA9109900326900F3E799CFE13A06BC23BE40EEA3032
          5FD91F544E9E5F4A2D4A20EAD4575A4C389E80C53D0630F0A03F025381C05381
          B9BB388EAFBC20192760AD00157AA2C22BD9CED24EA0858F3BE0EA71425D19DA
          6FC51756ABB54CCC28013BEE7C2C1F8A02EB9E23555BA97627C4F96388A1CA9B
          F52E2AC7324D20685CC96D2351614568DC4A31D39F007492E833552E01B5649C
          0051B1018D738685C66DB74D0AA24E0B11721CE67FABD6F49019023E29FD6396
          E687DE59FADD0C7629883C3389845FCA85898C2B7099123DEFEDD0F816B98848
          89162705BFDAE4DCA226E3042848D6531FBEFE2EFD17E472BFD55AE688167709
          50FBA83E3F94AB012339624A04AC50A534DBCF1D1C8C1ACAF5BB581A26015493
          11E7C45C3D5A1A75CD9408582312E652092FA0342BE06EF621FE5F44F2C31421
          9F35B98D2D1447BA016911F0CD8AD53E72FFB111A3828448260EA2734AED364C
          9747300CE4238F0000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage19'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000006AE4944415478DA
          A5970D50545514C7FFEFBD5DD84F76D9352544D3C91059541457F3831A9A4CA6
          9A4663C6462DCD51B32432089B32C6322DFB644C1BC74CCCD219FBC2D1D20A75
          B1AF21AB41CB745450C00F60119185655976F77D74DE2E021B6F41ECCC9CBDF7
          BE77DF39BF73F6BC7BDF651041E64D4B4A6455EA152CCB4EA521A33447922408
          A2C408A2C8F282C8CA7D9EFA42B02F32F490B6831702C139A1FB7E8D8AF926C1
          6258BBA7ECAC17910C93F3E9FF5C69728C4F1B147D8FDD0A6F7B073A7C013092
          008E11C181949182AA66A965018E63A022E558520EC1F693BDAD38F0476D2FFB
          89F196C6B41183EF2408B722C0E3F78E3BF540569C2D2B730818910FAA18E0E1
          72B5E37A73079AAE7BD1D2EA8724C8F7C44849C4C75FB52802C8322D31FEBDB2
          8ABA55BD0028FA94F861E6636BDF48D233A2D009207481DCE807815ABC04E4C3
          355700AE3601A22885D9DAF6650B0EFEA90C30E236B3B7A6D165E805307F46F2
          FAAC45135E9E95A166FB02E8D9CA2208129ADD3C9A5A025D401F7DE18A9881C1
          66BD30D4AC4FEF05B0203DA570E13369B9D327331808C07F45065AB6A60E3B1D
          558AF787C41A0553B46AB1324036014C62149D29814492A75F7362DB0F951101
          F46A768512C0FB8BB2D3F2A6FD4F00F9157DFAB5067C5C720B008B73D2F2EE9E
          F8FF0078FA0BB2D71140840CC411802E12C0929569799353FB0208075112BF5F
          42CE9B4E02383F5000DBBB4B57DAF3EDA9B8098050AB24DE0E11CFBFD51019C0
          1223E8548C32C0B2DC49F993C6B17D567E7F001EAF88BCB7E50C5C1838C0F23C
          7BFEC4B1CC2D019CAC6CC7995A15EE4BD5A060E3958800B713805609607EBAED
          9D675EB0AF9A90D21B40A4FDA0B9A6058347EA140102BC889CC26A142CB7A1AA
          3519BB8B0E60FBAD00ACC8B7AF4AB531614E3C57DB50F4A8039EEB3ED866C521
          333F110613D72B03B95B5B307BE668582D09D8B4713FB697540D1C20FB45FBAA
          F163BA0104AF0FFB5FF80D15A575B403D22A474BBED6A4C6ACDC5148CD1C14F6
          BC8FAADFD56100CBB762F5074E144502B01200D709B006D051B3913489577336
          739CC162B4A8A18A6283939B6B5AD1D6D881289ABDD2029477003FB5874046DD
          1D8B875F1A05739C26CC41C33501AF6C7662477F00E45C7EF220E97DE84746A8
          81C566EA2C7916CD278EA3B8B40C9703446F566341A10D43938D5D73EBAEF258
          F321011CAA56B4156F35091A0E41802C1A7F6DA58F88A762690995D3485BBC0F
          2C29039EFE025A5583D10F2580604E663D02146C8054B81E8EDD7BF00B6543AD
          613177C318DC35D5127470C5C9E3D52D4E7C7213005B69BC9CDE1ACC197307F0
          C432E061628A3191D528A0F63250FA4348FF2CA33536D0698288EE7F90E6A8F1
          C7DE7DF8AE8DAE501073372423E91E2B2ED6F258BBB51E3B0FD7F40BF0338DD3
          ED5AF26BE8EF4F50108672A2D5A2B8C18393541BD17A0ECFEF9B0CA74BC2BA6D
          CE880043AD263E9A43B60CF03D8D332752B0E32928F9034B2E2E39EDF4590715
          D95777B63A15608C52E6F89B3E31F7521658CAC273C57634F938ACDF5E8F4F0F
          5F54061844006C08E0731A3F36818C2728AFAA61924275A251758F69ED411DD5
          80C30FD4D0BE34636102EE5F311215D501BC59548FCF8E44023013801404C8A1
          F126F9E224A21F2C474B7DEA860A4E0A39B9F1B967A4421C6D0AF5E9CD44AD07
          B8460FFC42A53164941ECB76A4065FDFD3957EBCB3B31EBB1C97FA05B893C6CA
          5B560F91A1B2C8793B39D27221A80041F9E95A095DB30ED362C1E6B1A870D2F8
          D7365C72FAF0E32927AA9D1E457B0904102503C8038248A2660E698C27D69031
          2E63F8144B2CAD84F25D7A0DCB7755400888B8979CC504BA8D78A81E4A29F55A
          6B14DAD387E3925BC25F55CD387DD14580629F018501F494F9D393D72DCDB517
          4C9EC076ED0347DF2EC7EF3BCEC1C884562B19AC92FE9FD35433012A88A3163D
          CA1BDCA023509F4E75F4B6E8F53A180C7A9838C1DFEA6ECB513A173C347B5ED2
          D70F3D18ABB901D078A60945B34B82F7F5A41434E444D4B02C8E9862A0321A60
          D0EBC9B83E683CD4D7F5E8EBA1D3E9E8C4145ADA79BF0FA71DDFB6171F3B3B4F
          09809D3223CEB574F948A37CF83879A2098ED2EBF01C3A0FCDC56BE8AC4B70D3
          A7223A73262D030C062A0D17CE8AE7FE2A777C77FCFCEB8A4F3F99316EF598B1
          E6B50D8D50A96212601C320CEA680DF893A720B9DDE0526C6029F2818AFCA5EC
          BE5A8FEAE365DE5FCF5C7AF97293FBAB88F8F366D80AA87989E5544CD711B6FB
          E4C5FCF782B2C7F0A1280A1C9D90AF9EA8AADB52E9749DA04B25FDE54F171FAB
          CFA0E2B2CA4E2900A9A759490EA9DB97D4196458CC9DBFC17B7E5EE0DBFDBC7C
          2C6F20FD87D4FF2F6E10AC7F4280C9A50000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage12'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000093B4944415478DA
          A597095493C716C7FF21842424101671ADC8BE08D65DE1547DFA4EF5F94EADCB
          6BABD5277AD04A418C4A415A1651C0DD5614DCB08A208AA042AD1B5217548A3B
          202E285A5110100CB2EF84E4DDF908D405C5E39B937B6ECEF77D77EE6FEECCDC
          3BC3C30736AB8163A6D754943A3537D62B1BEBAAF31BEAAA72E9713149258925
          8935898AE411C94B922A8DD4BFAF5F5E578E474FFE5E402AA538EFEEB882DCEB
          E0F178686E6EE6DE99DA0E3B0DA8530B1FDDB29348745DD9F3A6A62625BDCA27
          8925C960B6242DFF0F8027A9AD8AFC6C1849B4B07AF56A94949460D6AC59701C
          36166A6D5D3CBD7F5D3DE3ABC9BCE9D3A7A3A0A0008B172F464343C33EB23B4C
          728EA4E1A300C8B92EA9C7243D458DF9D0D793803991C964F0F0F0C08C193360
          6E6903B9A73B07666666068944025757573434A34062D02D56A56C89287DF6B0
          F46301FC48AD9938CE09476223E0ECE4843163C6402A9562D7AE5D90EA1BE133
          E791F0F4F4C0F1E3C7B9A9118BC558B870212AEB5AD1DBDC01FA463D1A043AA2
          53D44F12C9C9B46391551F0440CEF96C2EC562619F7D5B83616B6D091F6F2F58
          5A5AC2D0D010696969888A3980EEBDFAA2302F07494949A8AEAE86402080B7B7
          37742552388F9980A2B27A282AEADABB658BE704890B81D47705309154F2B753
          C763C2E7FF84B5A911222323A1A7A707131313D4D6D6223A3A9A73DAB76F5FCC
          9C39935BA0ACF9FBFBA3A94585C0A09518E534144D4A1E2EA467E0584A1A2AAA
          6AA06A556E4E3FB9C7AB2B800452D30F6C0F46E6FD67983A7E38121313A1542A
          616464C4859B39D4D2D2E2A4AEAE8E9B1AB55A8D9090103C2D2CC102AF50D8D8
          3AC079880D4CBB0971E3560E7C5686A3A6529174EB52D277D47F05EF1DCE8D48
          150F72B411FE1CEC851DD149F072FB06292929DC88757474B8B97EB531C70CA2
          7BF7EE707373C38BB24A2C09FC05A69676E8D5C70C23ACA538979A86B0C87894
          15E745DCBF79663799DD7E1700B7F55678CFC7C0418370FADC6578BA4E83AE58
          88808000D8DADAA2ACAC0C42A1B02302F5F5F5E8D7AF1F366FDE8C43870E61DC
          C469F87AB63BEC070C87482880B3AD14FEAB7720EDDA2DF5DDABA75C2B158557
          C947EEBB006ECAF4244313F7AE4361B90AF54DAD282D7D8E201F775CBE741653
          A64CC1A2458BB848A8542AB4B6B6422412710B71D3A64D183C7C14E679FE884F
          8738435BA0831E06027C62C4C797B3BD5153539377F574F45272C30014BC4E9C
          0F60A19931E573B8CDFD0A8F4B1AA1E662CCFD101713895F56F963C890C1080B
          0BE36C28E9E0C18307DCF633B3B4857C5928863A8D8648AC4B5303D8F41671EF
          7D43B6A2BABC3421FBCFA32C49511685AA33805052817BB704C2D8A427CAAA95
          9C63B50680FDF9C1732E5E143DC1B66DDB389BDCDC5C28140A2CF3F5C59AB0DD
          B0B4EE0F2B5A7C6ACD2A1F6826A1B93F88A3C91759D65CF6EC51D6257A7CBDD3
          5D4000397D7A9AD81F8C0C457105E5F666751B8026040CC47BD13C94143E4644
          440467C346C7D6C44F7E7ED8BC330EBDFBF683A54D7FEE7B7D5D3EFA9908F1F5
          7C3F94BC28ABBE7C32CA45AD5665A3AD5EBC0E40CEED49E5CC9C36010BE64CC3
          F3F2E68ED1A33D0A0C403E1FC5057F213C3CBC03804520202010DBF7C4712979
          80A323B4B5799008F978565804D725AB505F5B999A713E81CDDB5968EAC39B00
          81A442776EF89156B429AAEA5BDF00688B86CF6237143ECD456CD85C48D4CF50
          F05489F422634A3C2148484880B9B9391C1C1C3AFA8D3D9C8C5FF7FF0EAA091B
          1F66A59EA44717DBDFBD099065626C30E8C89EB5A824E74D2D9AE06B0058E211
          EB68E107F9F730D17E807521DE40DA26A0840785440FE6F28B888F8F7F0BC07D
          D97ADCCBCD53655D4C9C5D57FD328B05ED2D00726E41EAF17FBE188B250BBEC5
          CB1AE5DFF34E2F582875455A9C81BBBB3B8C787769C11D048ECF024A7928134B
          60E1958EB8B838585858A07FFFFE5CBF95947AA7CCF5455363FDBD6B29FB5871
          4B2729EF0C6019A90D5B5679C1C1DE06B58DADDCC8F95A8054C48736FFEF6079
          7A7AC2087710BA9176D3C93904000210C3CAFB1AF6EFDFCF152C7B7B7BEEDBE4
          F357B0764B0C2A15453177AE9C8847DB0145DD19C05599BE74E4D1E80D60679A
          16A50A4281164414F2379B5C2E87A13A1B21EBA308601EF0A20DC0DAE73A6263
          635F0358BE2E1217AF64E151769ABC243FE7323DCA7CB52F9EC6F927A40A268D
          FF8CE7BBC885321F73CEA3D1775EAB962E5D0A03551656AEDD45000B3400BAB0
          F5BD819898980E8096162526B978A3B6A64E71F9D49EF91AE7459D01C849856F
          5C21C7C8210EE8AAB17A2F53662268D5568AB13B01F0F0922260F75326F6EEDD
          0B2B2B2BD8D9D971D5CF7B4538EAAACB93332F1CDE4EA67FA0ED4CF016C00589
          AEE81FC7F6FD4C070AED2E017C29E3E9B7DC4060F0660258C465F472B108767E
          B7101515056B6B6BAE606DF9350189275251FCE45EE8E33B7FA66816203A03A8
          1BE860AD1BB1C6BB4BE7ACF951C6D36BBE06FFA08D94D1976A00C4E81F908DDD
          BB777700CC700B447189A2F9C6D9B8FF3635D4B2ECF7E82D0072CE864CF642BD
          953EDF61C46007F0F95AEF05602559DA74157E816B29A83EDC1AA8200087E577
          B8B3A28D8D0D744452CC9187801C675C3F7320186DC9A7BAD3088CFAD22D9092
          0C2B423094E9C1C1CE023696A6B02561DAD850F69A51505010A48D97E1EB4726
          B78F00F732512112C071F93DEED8C6006EDE7D829D31BFA1BC343FF2DEB5D389
          6476A6B3C1742C7347E72FB64865DDFEAD2D109A118CE0D58F8C0DF539101B0B
          122B531C4B3C881E5A9970F1D8883DFB4F62C11853081EC662C0CAFBD8B16307
          17FED511F1C8CB2FC2FD1B7F2C287BFEE4067593FD5E006A6C984E7C6D1D714F
          533B3399712F6BB15466A523D4B5E20B74FA1114BFFDC3828719904F35C06497
          B5483E938E6923CCA1777F1B06063FE04A74632B1FE151BF43D9D2947F25399A
          ED300650D215006BECA0D743036340A2C7BE1108C53A0465AE6FD4D34A24D1B7
          2E2DC81DEAFA2F992CD8E35354F127C2E0C901141497C36E713A464F988AF2EA
          16103C9E3FCD59FDD7EDB42B683B7CB47E08C09B8D8D5A5F03D30E2525B1A763
          E0FA3BBF7DC3B3EF5E8206953EC67ADC464E7E03CCEC86D165A4179A1BEBCE66
          A41E62F59A5D6033DEE5A0CBBBE13BA018CC2A128FBEBD0C50FCA28ACE85EA56
          2D6DC11E93DE9674F3513FA5283D43DB6D3915EFB9217F0C407B63DB771209BB
          C0B02BFA79923C4DC41820BB11B32BBCE27D9DFC0FECCBCA4E54D575D5000000
          0049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage3'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000004174944415478DA
          ED565B685C55145DE7BE66269349A24ED53658ADD3903EEC4F6A9BB45845D41F
          2D2A3EBEF4C38F1A0505FD1014D10F95FE0882041F25882DA28215452D458ADA
          870AFDB182562DD4548BB1069BA699C92493FBBEAE73E7DEF4E6318E3318FDC9
          092BFB9E3DE79EB5CE3EFBEC7305FEE7269604343238775D4AA3E92776100789
          5DE5AFADA1FF4400C96FA11920D624DCC7898D14E12C9A001267685E241EA931
          FE190AD8B9280248DE43F336B136F669172BC86D4AA3F84505811BBAEC48DC01
          C2235442275AE51411E4C8DF8933145BAE2B80C40ACD93C473D1641C19A0AD37
          83B6BE34842A30FAC124CCD34D45FE0FA29F42F62F2880E4A968D5F7C43E63B9
          8ACE5B97A1BFEF51BC71F215D8BE85E2910ACADF58CD463E206EA68883B30490
          BC9DE663E286D0C160766CCBE09AEBD761A0F74DAC6EEBC696FD6B30E194E09C
          F750FED68279CAE1560417E2C9D829868092260C0582CB51185085D63AE3C21E
          F162BA5314B05A24C83B693E253684731940FECE566CDF7C0776F6BC8C5F2687
          F0DEAF7BF0D16F7BE72D47570CA84225B780104AE8B33C136E942471F34C1F23
          83250417766EAD88C80BA89EEB95B2AF640596DD95C303BD3BB029BF15832707
          70A2747C1EF166FEF6D48617D0DDBE6EC138BBBE1B0A29BB1314FF16760FBD8E
          E13DA37046FD78C86382E432C98E121B43F21681CBEECB61EBD5DBF8B285EFC6
          8FD5DDD0562D872BB257612591D3DBE0F80E61C3E152C7CC51FC58FC1E966F86
          63E724EF3E29E0213EEC8A3D9730EC2D05BDD9E4AADBCEEE2DC31A9ED99A4352
          802C224FCB5EC0BF150FB743CBAAFF68B2C0E31B5E6C83B00A84CFBE44382182
          40FE636E28D5641CFB648A5B309388610496F3E127A2437A3A6E4A235330A0E5
          FE5E847DCE855BF2D048A30E143F9F865F0E62D7BB71123E483318BA18FDFCED
          2D50320A8CBC16169DB9CDB77D98C34D1421F29EFF8C15B432E379351620ED21
          44E73F75A58AD69E5478AE8DBC0A95D110899A659F73B87ABF2E1914B9A9D537
          E5D6D8AC0393C76609BF3759072EA53982E8B66B59AF23D3155561EAD32F52A1
          312AEE940FFB6C35898422C282E49B01FC691F1E57E6577C3E0770D90FA68359
          C2E73439497E6E255C41F3255108FB7D068CCBB59A8B9C386AC2F9B34E246AB7
          C3AC84372E7417C862F415A2A294BD368574A73AFFD660568F7D58497AA6881F
          AABF84A345E2D98F562CE35F2264397D9F022AB56EC34214091911A4BB3464D7
          EB48AA90611E3F309D7CED7E4EF84EA361A8B94114D145B38FE8967D3DCFEF80
          2DA9EAA990C7E9B0096F7C26FCA749BEAA997DA8F741226F4779356F977D99D3
          E9553ADCA247F22039F4250A78E25F17108990FBF83CAAD572A1F172EFBB2860
          6451042484DC4DB31BD54FACB8C9A47A9CE4AF3543DE90804884AC15CF12B711
          3F47E4279A256F58C062B425014B02FE02BE357C54826B8ED60000000049454E
          44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage4'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000004164944415478DA
          ED565B685C55145DF7DCC7643AC9E4A1360F5B4DA4168288AF0FC556B156AD58
          4504B1FD6829522262D5564B113FF4A322F8A156FAA1C59FAA54412816148A3F
          2A863E9C562DD582D234A66D2C84D43849663299C77DB8F69D999B3BEDA47995
          F893CDACD9E79E7BEEDE6BEFB3CF43C3FF2CDA0281B91AA85B19E9A07A81584D
          7C42EC491DCAE5E785009D1B5409E2CE50771FB19D240ECC0781D7A8DE99E4F5
          5EE2651249CF88008D3650B596102152258821A7344C2756121F13963C353DB2
          08A9E35914FE71C3E6CE101B48223125013ABE9FEA33E2C6996622B2D4C0E267
          EAE0915EEAE72C468E8E4F50056C6227F13689B8977EAB959CDF8EE25C5AB399
          8ADA3B2C343E1883A999D8D2B9031F2676A1FFE020F27FDBE161FB4BD9C85523
          D04D759FB4CD6B15A2CB2CB824EB71A853D26ECE83972724068F3FCF833234D4
          DC6490401466A342CCA8C5B1C77B702EDD876D89CDF8F5D009247FA8C886F879
          9224860302741EA71E22A4A2D1DA158711D7832F242A4B8F20A222509A0AFA49
          05C3F9241CCF09078487DBD6627DFB26DCD67417DE3AF93ABEFCE90B0C1D48FB
          0194E414F128495C28137882FA6B7950110D4B5E6CC4BA8E4DD87CF316B444DB
          2A9C86C5766DF4A64EE3DD533B71E4E28F97BDBF21D68EAEE55B71367D067B12
          BB71717F1A4E2A28817EE20192F84B08BCCF8757A4D76852687DB63E30D251BB
          0C8BA32DCC8205531984858C3D86F3637DB890E9BF2CFA6AB23CDE89B8D980C4
          B9C318D8370A772CC8C431628510F8888DE7A547AF53687BAE7E4AA3B395CCE9
          3C86BE190B776D1402EFB1F1AA3F1F5C03CD1BE370C71D7F4949896AF227B320
          D035285FB39F6D991D8D85A82C352D02F97F1D0CEC1D29DA2CCA7621206BF40D
          7992C2BAEEE9183C7B5AF602D1630A911673D2F762D71E7691E9C963B43B5BEE
          3E4FDC2204B6B1B1ABDC7BCD538BFC653653A9596A56CD845BF0901FB4E1510F
          7E9582F282316B59840785C0AD7CF8ADDC1B69D711EBB4FCE9E01298D82B3D5C
          91985ECB2C344F6441F689C2B0033BC9746A9A1F79689BFE9CCE3700131B912C
          8B25570C5171E33115549DE63BD3639A0FABCD0886988D3ADFE970B22E53EEF8
          5143F3903E5140EE6C30AFDF97A2CF8609ECA67A69E6899795A3A161757492B9
          07B2BD3632BF07D783C3C41A3A0F9642F830BA9B6A3DD18CE2992027A184E794
          E086DA2B88EBCBDF56AD1B469EF9C3C6F89F8572CF71E2213A1FAD18369BA849
          F61EAA23E5EFEB57D5C0A8571556478FE650180836AA93C42A3A4F5E6A6BD617
          12929074DEEB1B61AE9A1E2B6641E67FA43B072F13A4E43B621D9D0F55B33317
          025BA93E080C99C59560272B8E7C59DE3BE87CD23D7B2E04A4F27A10AA859048
          8577D1F1BEA9ECCCF54EB886EA53140BB72CBD28A6FC97E9D8B81AD77239BDDE
          243A896F319FD7F2AB210B041608FC070B09764E913E14320000000049454E44
          AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage14'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000009244944415478DA
          A5570954935716FE92901002110C0809244842149C7103CEE8586B479CD13AB5
          7AB44ED5A93A3DB5A57ADA8ED6D1D156AD4E175CEA82E3803AD4A38EFBDA8EB8
          54512B9BA2C822100411A2100C0209202464212173FF5FF400060FEDBC9C2FF7
          E4FDFFBBF77BF7DD77EF0D077D18E3A62D5490984130111A08D99929FF36CC9F
          3F5F1A1A1AFAADD56A75EA74BA6D274E9C28EE8BBEAE83D307E3EF93D845E077
          997671E0D4C484F78BA8D0565FE0C2615028E4238442E115BBDDBE80C7E335EB
          F5FAC5C78F1F4FFDBF08907131092D2160DECCC9881E1E018BD58672AD0E9AA2
          7CD43FD643D7C421251DB63089D3C5E570CCB5C6B695628123542A0D8A4A4C4C
          9CD6A92A9AF015E109612B21BFAF04D691F8C7ABA347E0EF4BE250F9D8066787
          0B423E07D72F1E4570701094E191B8969587B2A29BA8A869821D5EE0C2592FF1
          EAD01A2CFCB56579576EB5D655E51E59BF7E50B146838493274DCD16CBEF496F
          CE4B0990710989877C0F0FF1CEAD6BA1370959E31D0C5C4079E175D4571561DC
          1FE74321F3C7F9E3BB11A208437DB30D6937F2D1D8DCC2EAA928CCB07D39E375
          CFB7E2E2509C9C8C338585D89E9676801E7DCCC4D4CB087C4A2261DE9F26E395
          DF4D22C516D8DBDB21128A88800B164B1B72D37E40B3418F4973964393938A46
          7D39625E9B82A8A19130D6E9B077DF0194A7272276981262871AC3FC6530797A
          62DA962D69A47B05E1F6CB08140AF81EC38F7DB711558D1C586D36945454C264
          3683ECC35F22A19D0783EF21603DD2EE68476941266C1633868F9902B3A9056B
          E3C6E2D67F57C1DB4B80828B5FA22067024E9FFB11575BCC5B6D56F38F64E62A
          A717E3514CA04C1A3F1A1F2E9887BAE676D688CBE5EA94409DD1006D750D6CF6
          76F6208383A49011B81C2EFB7CC3EA455837DD883133B703797360F75061DB1E
          0D369E33838C7F6D35B764908D9F7A23B083C45F93362E878F44815A63337235
          A55048A550C943C0E5F1BA11723A3B50ADAF45756D2DC549074AF3B311A84FC0
          86A47340E92AC0DE84BBFA8118FFF145F8858DB6DEBF93BE89F41F25DCE3B831
          2E20A10FA3C84A4EF802B58DED70D18709C0078F6A5151550387C3014F4F01D4
          0307421A10C0C684ABD333FA473A7CBBE4555C39B2023C7329D09889279CD158
          B1F912CEDE93C24B242ED2966433419848B0B9233093C4A92571B33121761CCC
          D68E6E0658D0A78DF24199B61AFA86066602123F5FA81472ACFC701A8EAD9122
          44351AD0ED83C3330297D2EBB128B91EFDA44360AC7D70BA4E776F2FD9B8E0F6
          1A1281B30201FFCDEFF76D82CDC947D9431D1CE4E270450828C37592E84288D6
          30C760686CC2BA35CBF1C9382DA6FC790DA05942DA05A86CFC35262F3E0B65F4
          343C32B4BAB4C559CBAD6DAD976859C90B04C8B82F89FAD8B13182D57FFB00AD
          16277BA6153A3DEE3F7C8476A713023E1F914A05E44181ACF16784762725C072
          6F0FB6ED3E03142D22E73E46ABC728C4FFEB0AF4A2D751AC6DA22C6AA9BA9777
          75312DCBC6D39AF2028179240EAE5BFE01C68C8A26831DCF77F96CC7568A7AC6
          F5BAC7F5ECCEC5222F14DF4CC385C3EB917333035CDD1EBA22E7E114AA70EC7C
          0376A67B61C6DBEF60FFB1F3143BF61344603FA9633CD0E18EC00F94F9A6A71C
          DA424FF8B853AEC5FD2A3D445E428C18A4847480E439211E876A00ADCECACAC2
          F43727E23FEBA23167F62CCA9DBB585D99E52ACCDF50826DDB77E0DCE56C1497
          D740FF40B384C0ECFEF60BB5808CFB306E79E537C384F1AB3E82DDE162E71983
          A6362B0A894C6D83113C2E97DCEF8FE8214A76F7B1B1B19838EE57F8C3F851B8
          7F231973C7D423B524188BB65560DD97EB111818884D49476177F18DD917F6BE
          472A0B09D5EE08107D1CFF6CF15F3069FC98E791CFBE445BE5F39EEE9819FA86
          46E497699199760D692907917264330CFA1A64A767C0DA7C03A7F2A4F874E932
          507986B1D9845D872FC1627E7229FFDAC9245A7E99607547E004EDEEED330736
          4324124153590D3F1F6F84CA0228BBBD98AC3A2838A3A262201F3105321F1B5E
          0B36E0BB94DB10874462DE9CD990F88A2193C99053FC00074F5E44EDC3BBF115
          45994C7F90D1550FA7D3B817E37EAAF7DE095F2D65A39A09B6924A26D80CECBD
          F7137B232A5205493F1F76E1FEFDFBB1636F0A2441A1A8284AC7E89183316BD6
          2CCA927C34B6983061DC1828954ABCBF341EE595D58EDCABC7DEB1B6B5301D53
          993B024CBBF5FDD2857330FD8DF16E6B7473AB1905E476E31313EC762B96C5BD
          0BB15F0062A849993A752A24549C18CF29147445E572F0E9BA36189B3073C1E7
          4CEEBF93937A682DA9C92234B9237088C45C26F904487C9159508A9A3A034202
          29D868D73E226137321A6A2C0AA93654D6D48143C9C9A79F2FA2870EC1D898E1
          F0F0E03D7FEFCCC50C6CDD75044DF5BA3D9A9B174ED1147304AE6E043A737FC3
          D04855BF9D9B567433F42CD8CC740B783C2E22C3E418A292B337C162B1B09951
          2010B0F1505E5D8BBB953AF8780B31E9B723D9F52BBF4E4476AE0665F93F2D6A
          A8B9CF7440053D3DCB107883E4F98FDE9B8939D327A2B7C11829A36C58FAA086
          AD7EDE941B464628C94B12B7EFDB6C764C99B70C9636B3FEC6857D941A91C7EC
          C91D01B6EFFBE7374B11352C027D1D4C31BA73EF2179C9C89E6490BF1FA288D0
          B3E3BA9E5384CFE377C2F4C470B620FD74329E66BF7677045693FC86F23F16BE
          3B831A8B803E93E83AEA1B9FB0D11F1916C2FEDE9C74086753B3505359B8F641
          C9CDAB3475C3DD3A8640484787F31697CB635786D33947A843315815CA4A35FD
          666AFFCF19CC357E6BC16730189AACB7520FCE6DB75B99EC57E99600F3153664
          54CC8090F01D7C4F51048FE7E1DFF5052E65A1817219068713210223D54A395B
          1F7A1B79456558FAC57650D9BD75FBCA91789A4A23B4F64AA0530E2784FAFA07
          F70F0856A9BD7DFDD5422F9F417C81979A5A30BF6E8B28272B8203C943039F7B
          6A904A016FAA0D0E8713AB37ECA6E82FA6F4ACDD519A7B3985965CED8D6CCF9C
          1344E84F600C32BD01EBFBFE818A007FA992484906797AF9A8F902A19A8E4CDC
          53995C1648DDB10375747DA9F43ECA493DFC89D361675C5FDC57023D87A89388
          5F1752EC7FC4009932481234502D12F7674979B0A4B8CCFB74659DA69A8AC2F8
          AAB2DB4CD7739DD0F84B09B81BDE3D0831F060CE6540885AE62DEEEFDFF0A842
          6B6E6934D37C2D21F765CA7E0901773A7A92628A9B817097607FD9E2FF01D564
          125F4A5E51500000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage14'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000003B64944415478DA
          ED965D681C5514C7FF7766763E36D9DD6C1215A2628C16A98AF5A588CD2E46AC
          35C45A8A25206AB150D0AAA0E08322DAA8E043A108DAB7821F415041E28BD580
          4DD5C8EE967EE883B6A1A5540C150B21899BCCECC7CCECECBD9E59B39B601277
          B249DA975E18CEE17E9CF3BB67CE3DF7325CE5C6AE01AC74417C2B62D96398BD
          E200D184FAA4007B83D43BE8FB88979481FCC9FCC4150188DEAFDD2E64FC46AA
          B1A0DBA2C5FBCDB4738874B1AE009184F6038907971A23CF235CC87B0A99C2E5
          7501F0FFB9676B33BEAEC465B46F0FC33CE9A070C15D68E66FC1F873B9943BB4
          E60091A4D10DC1D3BEDED6D784F046B5D25FBCE8227BAC80727E41F48518B442
          EEF31885BD760009FD59B27C98C90C37BE10035319BA221B30B0E9005E3FF112
          C6862F207F6661349096E0EC984D23BB4600DA7B245ED13B43B86E5773A5AFB3
          B90BDF6ECDC02CCDE2B59F5FC4D1D3DF61FA481EDCE6D565E71448BDD974F1D2
          5A007C48626FE45E0D2D0F856BFD3E447FE76EECB8B91F9FFFF1310E1D3F88A9
          A11C3CAB06719983F7E5D3A55F5705104DE85F088827620903D1FBF445E39AAC
          E1A9AEBD68522278FFF4014C0E59284D97ABC3A6E0A23B77DC3DBB9A081C21B1
          BDAD9712F02E75D97931B50537E81D383F3186894F4D78B95A24CE5A8AB379B9
          C40C0250A901ED3B9B61DC16AA37BDD20AE75C4C0FE7E79D083C6A669CE1C600
          92FA293A5E9BE3DBC2086F0841D2A5FA005423FCA4AC36C1584F2E65FFD46804
          CE90B8BBB5370C462960746A60F2D273B927E04E78B04ED8B0C7BDAAF3CFC8F9
          D3CBD90F02F023899EF82306248341BD3E0425B2380A9E59863BE5A16C0ACC7C
          5FAC764F4251EFB446ADA9C601BAD54FC0D81E3A0D08B54B1508BD633E19B943
          BB9EF448F2CAC530FD75A17A3509C1443F95E7AFFECF7E5D80E684FA16037B5B
          BF5541D3A67F1DCB1119B2CE502E702AC5BC6629FB4D11BC54F58E7DB98C73B8
          9EFD0011D09FA1341E949A18E20F1B4B4F921866468A28CF152132FAF2DC355D
          B7D58F40527F800931EAEBAD8F851727206D387B94765E14558BAF5A29E76010
          E781005AB6E8B7942531EEEBB1A40EA56D3E01B92D901DA1FA529E0B3BC4FE5C
          DA7D37A8F340007E80E924FC49B2030A436B9F413909D8173DE4C76AB7A0439D
          FBAC943DB812E7410110EDD6DFA18C1EA82DA220885AA5C55F8CF1C7CD54E9D4
          4A9D0706307A8C9B148FFF4EEA7F2F830C3D4E77ADE6711AF8551C49AA3BA9AC
          7D49AA7F2138F47D60159D37F10B4A8D3A5F1180DF625BB46D9CE11E39C48666
          46EDF1D5386E08603DDA3580AB0EF00FF65F5E30F6BD3E790000000049454E44
          AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage15'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000004804944415478DA
          BD977D4CD55518C7BFF7C2E5F22AB11090971633331421992D0534D490DED65A
          190996C24C33AA052B66C6CAD9E6CBC8C242252D4DCD92DB9B3407A6C0204856
          3394972C47458421394879B9D485EE4BDFE7DED3BA63FD11F0C367FBEC9EDF73
          CF39BFEFEFF93DE739E7A7C3F86D21D9444E923D64683C93E826206037C951ED
          23E4B16B2DC0F4EA03D1E99D830E145777B4F23A4E4B01BEE479124A72C95FFF
          D1A7FA9DCC194B3CBC7C917DB059FEF727235A09D840B6DF1811888EAEFE6AB6
          1F22FDA3FA349BB26F890BBBCE0777149D93EB78D2A29580D35161BE89E76BB6
          60F9BA129CAA6F3B4FDFBDE417B73E5D154FC686CF8DF4C3B482AFE55A72E088
          5602969193DB9F8DC333EB33919E7300E5356DBFD1771F69547D2CF5B9F1C6E4
          E9531098DF80018B6D077DF95A0910337919F4E95FBDB71431B3E72223EF18CA
          AA7E90A596416AC860CBC604CC09F7C3BCC27368BC683E455F9A9602C2C98598
          E829018DA5A9D01BA722FBC54A1CADF8C946FFEBF2B43DDBE623D8DF80CC8317
          70B4B14722344D4B0162B2028A9E5E71138A5F488043E78D8237CF60DBFEEFE1
          E5A183A528193ACEB0E1B39F5158F5ABF40F213D5A0AF050E15E7862F722DC95
          14E6741E3ADE812DC5AD687B699EF3FA8DDA2EE47ED22ECD3B49B59602C4A416
          344E0D32469C2D5D86C8501FA7F3BBB63ECC3273F90F59F171532F1E665468CF
          A9D7A3A900B1DB495D627CB057EDFE14183CF52EAFDD0E5C34A3A1AE1B49AF35
          3B8343B2264380D83AB23777E5CD28CABFD5E9B059AC700CDB71A5ED2A42D77E
          E10C0C993D5902C4DE268F9B0A17207D49042AB2AA588E069172380D111995E8
          333B2BB6EC925F4E96002FB28FAF60F525532A5AF6B4C2D23980B45D8B515CD6
          8EBC122998F880AC9C2C016281A46BEBFDD17E1BD7CC04A61801AB1DD6113BEE
          6649AE6AEA956CFC8678C3B537BC457AB5142076282D2668D5E739B180418FF2
          2E33962684A0EC74373276348DEE2B9B581E79574B01F7840418CA2F6F9D8FF6
          5E0B66BC72063323FD1D5706477497FB46E0A9D799AC768764E50AB28838C853
          A4442B016B6F0832EECB4D0947BFC586CD273ADFA7EF382955FF4BF88755FB65
          B2598990CA7576A202D6C0B51A9C63A5248FD81CF9CA7755F983C9EF6E63649B
          96C4AC258B2722400A5203D17B1BF4750C759479D816ADA706BB03517E468F86
          A161DB7425F280DBB84822B5DA4022C8A5F10AF8882C279FC2754AF25182A432
          6DF2F6D4FF69B1DA0BD9969D490AD280DB58E9B780A4AB79C62C40FA0EA99B26
          A909C5B2E0CA70A9C5B71139A0727DA21EAE53D4A0EA27E78554F208F9703C02
          22D49389F9913F545B9E5E0E85661240661159019207DD6497BA8F24A2ECAE73
          C8B7E311100357AD9793AF64B943F9E59DFF48E4A06254BF724095C48B1D35C7
          5EB27E7458FFAFF9A8572063A2DCA291AAC2DB41A2DDFA7B924749225C0715C9
          1B13FE5D9E631620D6AA9E4A2ADB4EE59352FB0439461E1CE37C631620E1936A
          2689B58A5CAF0478AA48544DB60079F795247994FF30593DD69B8F4780987C82
          C9378084DB02D7F65B0057F25D1301FF989CCBEC1318EFB4BF01379252302F02
          C5B40000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage17'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000006944944415478DA
          C5977950144714C6BF65D9E5589643F088E2899820D178C578A04185A88807A8
          A0461154402813C5227861448D8078179642C48B042D4D3C4BA35163B4128D46
          D18082287860A0127559908808EC91D7B333ECB86064F58F4CD5DBF77666FA7D
          BFEE7ED3D323C1FF7C48CCB979D0984827726DC9DEE1AD9528665643B6EC97A3
          E917DE1880449A93EBFC0A6BD65812A59D2D6C6DACF158550EBD5E9F4F009E66
          0190A89C5C2C5930597721A95B0757347354C2D15E09077B3B383AD8C19E6285
          C20E36B64AC8AD6D20975BC3C64A0A177B19B6651EC0BE236758737782283207
          E07B72E3BBB8B5C3E471BE70EFD41E8ECD9C515DABE3EC39B31A2D990E35757A
          E8747AEA29A025A31E83FEA26727051E14E56349621A4B399A008E350980C46D
          C957756CD71AE9EB17A3B44C838A2A2DB4BC8820A08321D653A0E3CFB1EBDC35
          FAE9D2C606921A3542E62C6779E3C90E92B5E4EBA4151F3F26DB4E7095628036
          E44B06F7EB81C8F0304E5CC70B93AB17E24074065FA7D5A24CAD86EAC9133215
          542A15AA2AD5282B53E1EFC765AFEB743A01CC1603BC4FFE46E0286F8C1E338E
          920B3D070FA08746A3455EDE2D5CCFC9C1FDFB0FA05697138C0E969652AE3E9C
          B83A6135A2E4CC89CC81D58BD2816AC90E2ECD14B092596249521AEEDC7D5841
          004E62805EE4B323430230D87B086AEB74F5E2DC1093D0F6DD7B70F9F7AB68E1
          E28461833E04AB157732176767D4698017D4A6DE6A992768AE23C6A9EAEDA6C0
          BE03C7B17BFF0F4CD795204A050037F245E1D3C662B8AF0F97A47E04C88A4B4A
          F1E58A1478BEDB116B96CD45B5D6124F9F6B50AB31D688500BFA976AC338922C
          F670B5C1D5EC6B58B16E07D31D460067050067F2AAA9E3476062A03F57F510E6
          9E7C7E412156A5A42278AC0F26048E45558D565417C65AD19B089B02B56F6E05
          D5A35244C426B1F4D104B055009092D704FA796366C8446E085923F0557F393B
          17EB523330676610060CF47AA967C6A9D28B6A46F45F04D4C24106854C03BF29
          312CF546028811AF03952387F657CE8B9AC68D80908C05E72F5CC1A6B44C2C8F
          0B878767B7578B370620FAEF686B89564E328C9E168BA795CF4E10809F18E0E1
          C7FD7BB65D1A1BC14F8131C1A52BB948DAF035121747C1A3ABA7611112861C7A
          13988653C28D029D515A4BB951885E90829B05F7EE11809B1820A7F707EF7567
          4556C38A10C6A437F20AB168E546C4C784A15FDF3ED0F00B141A85680824B500
          ECA9F70A2B0BAE4DE2C65D38F9F325D64B5B82A811008EB76DD3D22F73730257
          DD1001DC7F5082E8B844CC9F3D05BE43BDA0D5EA8D42DC8D2241D1944828B382
          DE1136242C7EE365D26398917594859E04902F006C91CB6551A7F7A7A256AB33
          24E51B54945720287C31A2420311E0EFC303C064140C818E6F632DB380B5DCA2
          D177FDD95FAF22614D060B0309E09000B0805CF291DD29B0532AEBD5A55209AA
          ABAB3172720CA6078F4248903F37057809C0086449F75B91B8C57FEC326825C4
          ACF9892C5C4400C902C024727BD3D72EA455AE3D84E2B0A04C4CC03B201A13FC
          87207AC644038069EFE9905B4A68BE5FBFBF795EFD022326CD63E12E02081300
          FA93BBB8821EB5C1037A73378A7305842D40370F37247C11C1BD2521CC3D7F5D
          463D9798B1B70A088D435979E54502182800B426571A1D361EC1B41F30CD1515
          B79A5B50D25216729ED7374C13919AB5AFA3E3B3C56B9193575446002E02007B
          46AAE98D289F1731A9418384B519F8E3C61D1CA61A1106808DBF44625ECF8563
          75EA37387E86DB36BAD4372788A2817DBBBB252D896ED0206DF741EC39780AA7
          BF4B855C26339C9498B9A3151D59077E447AE621160E1403FC447BC0A13B37C5
          376870F8C479AC4FDB8BACADCBD1B675CB3794351EE77FBB8EA5C9E92C9C2106
          D8413BDBB06359EBE87192BED4E0D4B9CBF86AC34EAC5F3E177D7A78BC35C0AD
          C207888C4D6661B21820825CBAFF275E70EFE88A8AA7CF5078EF4F14141543A5
          AEE0EE899B3315FEBE5E6F0D70AFB814A19FAF64E116318082DC4932B102FBD0
          C825CB219B353DC80F333F1DF3C6C26C4D29F9EB31B67D7B04E72E5C63A7E21B
          FB30E909C3B70113CDA347A58E3FAF1A3EA49FF39279A14D167CF444CD0DF76D
          1A45E6D92AF8ACAA5AB87C9DCCA7C9854C00D9DDBB76EEB53929B6D1EBEA8A4A
          1490089BB282C262CE573CFD477C0BED1E914F964DC6BA9F459D2B370760A7D4
          C2227415ED0B9A3B3BA29C92DFBE6B10633D649F65A2A396EC262F2408E692E0
          0BD3BCE6007C448E6D246D4D2EB1A4B926623749ACB62979CDFD3AEE402E88CC
          1586396482EC6354634E1EF1F12F3AFBAE4327FC98670000000049454E44AE42
          6082}
      end
      item
        Background = clWindow
        Name = 'PngImage16'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000007E74944415478DA
          9D570B5094D715FE76975DFE7DB1CB02F29297C860880DAD8D656CACD5FA485B
          AD3683D8719868CD609B3721D347901AB13653531D6A2691A899600B8AB62A89
          6821282A3002412382F27EAFBC1796D7EEB2EC8BEDF97711D95D08983B73E6FE
          FFB9F79EEFBBE79EFFDCF373F0146DEBD6AD5CEA024942490CB9B9B9779E66FD
          6C8DB30050918F8FCF2D5F5FDFA542A1502E1289B81289040FAAAB1FC9D3D37F
          CC07FC2749AC2464CC1FF6671F7ABE4A6CFF9D0A4C7E6702498050022CEDDDB3
          A72C30385812161606373737DB584D4D0D74595960341A306363B31ABA0FA45C
          012ED263D3820810DB000BB09D945BE87519C962339FCFE9D8B4098151510808
          080079C336D762B1806118D4D5D52164A0103F0A9D84D88B8158C1A0B37A1097
          53EF420DDC3A0EA4D1F4DB2423DF4AE07D601B75974878F2003182A2BD50EFB3
          04439ECF412C912238381862B1D836572E9743A15060D1A245C8C9C901B73F0F
          1B2287C1E172A1F096C13FC80787D77C81519DB9ED0890484B5A481AE624403B
          F7A083EAE7F238CCA677A3F1FC8E708CA83548CEE223286225643219F87C3EF4
          7A3DCC26030C9A5E58C73B21E38FC247624280CC0885C4623328960811F1CC62
          9C8C2F4457EDD0C4DF803852F7917C332781BF006114306DDE611EF8DDB99FA1
          B9A11B26B305753D42B4A945F0121908C80C6F12B9D002CE94DFACAC811987C8
          BEBB337C442D0FC6C5E4AFF130FF11CE02BB5B01250D15CF49603F104D0F554B
          627CB12E390A6ADAFDF4048EDDB2D56521C7456799E44067E2C3978EEBD67FBB
          5059A24693F7E21BA38C48255128FE509A9BD133D711ACA12328FEFEAF42F16C
          7C1074E306D7EF630ACD4C138774EE50B1A275C78086849E07B40C4626042E3B
          948885D0EAF49818D754DC2DCC7E8D545598B11FCE5400AEA3EEE6EA5796217C
          B31FC634132E86D8A3B8D1B408F52A29ED9487E0405F84850440EE21855C2681
          4C2A8587CC0352CA111E5231A4241291184286870B970B702AF30B53795EC676
          FA7ACAC8DCA0B30756D0C6EEBDB03B12CB628330343CEE003E34CEC7E1EB11F0
          F6F1C75B0971581A1E0E2B970F83691246B375BA77712F9D9F42E206554F1B92
          F61F43FDDDC2BD83BDAD6C2C343B135842045A5752F4AFD8B31403835A87AFF4
          618F04A74A439076E81D287CC3A0373E496E2E09C8492165B8105875884BD887
          EEB68707DA6ACA72A78EE1C9F464C08B52EAE0739B43B03A310AAA01AD83918A
          761932EF04E2B38FFE0AAEBB07BEAD391372E773B0D84B808D716FA1AFABED64
          6D457E16A94B9D3DE0467B3245AE0DC4CF0FFC003D7D1A072325CD729CFFC60F
          3999C7A03570E6069E6588C7B51378F9CD83A8ABADB9525974F113525F73214C
          81A8098BF195BC742406DDBD1A87D1D21619CE54F821FF3FC731AC35CFBAD5B9
          2E152EC5819F271FFB3EF814378ACB2AEF5C3F7380D405242667025D81CB1581
          F127D7A0B3D7D103954A314E14FBE36AF647D09BB88EC07320B37AA1800B913B
          8F4800C7332E22FB525E7F59DEE984A92318762650250F1447BF9EF32294DD63
          0EC6D88C98762D00974E7F082E5F3CFBCE671011B8712022702EF789F2F25725
          389A7E76B2BCE05FB116A3914DCB5D0ECB281B5EE1B971B7BC57F612BA7A1D33
          61C7A03B52BF0C40F6A78720957BCEEA708EEDBC018680795CD7F17BD50D487A
          FF181AEF17BDAAEA6C2C2255A303013A98E3F425BFFEEEB52D1836981D308C10
          23E194373EFF678AED4AB63A532096EEB46B37DEDCE5459F4A8D1D7B53D0A3AC
          3DD45A7DFB32CBC9F908FE4CDDE184CCF5E0F93294EDEC8985CD640C23C42FFF
          EE89B48389581E15E97007B006047C2EB8F3D456939393F429BE0D556FC7E735
          E5FFCB24558933819DD465C7FD6315FC567AC344D98D43567D3C19F0C8B72F1E
          9223F1D5DDD8B8761511B04EC3F369D79C790B3B7B7BF98D54B680C9AF2CBAF0
          31BDE63BC7C00BF4727B53523496C786C168B4C0432280BB80671BDFF5B107D6
          ADDF865DBFD90CEB143E7BD60B05675BF207E9B85952FEE0CEB53329F45A4832
          31BD3C95CA2F4A469D313B23B036F17B04628558C89F5EFCC74C09BC427F8A3F
          BDB90B3606843C9FDB9DDB27191770EED257EAB2BC8CDFD26B39897ADA04952D
          BC6788116543B7B823ABA8F8E4D82E93C7ED68AE08DDA6688A8377ECCE7F4A70
          B67D995F8CB413E7AC15D7CF6E37EAB56C102A1DCC501C74F82DF30C79EDFC46
          97C599C50C0A1A427136FDE0D3234FB5E2F2FBD87FF8249AAB8BDFE853361491
          AACE9940895026F8C97BC5BF76595C5025C091AB7214DAE2E7BBB5290FA0F1DE
          CDDFABBA9BD96454E94CE00C75F1295FC742C0F01C1657B5F3F0F6690FE4661D
          A52244B220408D761C8D2D4AD4B774A0A159898ACA5A8C8FEBBAEE159E4F341A
          F5ECBF428D33012A6291F24AC63A84ACF099D69B0C163CA8D422293F149FA5ED
          436478B00B98C16044535B270111180B4A7D578FEAF1B0D56C9C50998CFAFA96
          EAD28C1175772FEC41A87326B09EBA42F6BF2062B51F0C74F3A9DAC6A06A1EB1
          159C651BE311BB731B766CDB80C1A15134D976A7B481B62B7B688EBD50319B8C
          6AC384AED5A0D7346947D5F5AACE9646BD7688051D85FD07852DC90CEC5CE758
          E6504A3E411FD9DE996346A057473F17ED91CF7346237FB87AE6028BD9386234
          E8DBA8E86C1E1F55D70DF6B6378E0DF7774F013D06642B1CD79A0D735CE39425
          82C8797B1E91F7A9766AEFA7E3845DC69E8DF945B81B9FD9A0D50C0CA8BBDA9B
          C89D8F9CC0C6E6025B3081198DBDFCD988D3B19B751A63FF522731CFDFEF7CED
          FF977C0B4EBD0E02B50000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage18'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000074A4944415478DA
          B5576B7054E5197ECE65CF9ECDDE7261494874B829A554CC201321025A195215
          29A03F2AED40AB0CB6744A477B8199D65A5B35D3321594B15A15B53553EB38E3
          6DA4D41206A9D3280152458511C2C54428119265975C76CFEED9734E9FEFEC6E
          089B4D60B0EECE33EFD973BEF3BDCFF7BECFF7BEDF4AF8829FE05CEF449A1F12
          3389B7882D7D2DA94317FBBEF4059DCFA7D94EC8058F9A887B4824FEA511A0F3
          00CD41A2C653A920B234804CCC42E2531303FB52704CFC97CF5691C43FBF2C02
          DFA7795A5C9735F810B85A1F7C96E9B310DB91807134237E3E43FC9844D2FF37
          02B9BCFF5BAC5EFCAEFA6E082B67AFC6C29AA558BFFF01EC3BD3E68E4B1E3111
          6D1E809374DEE6CFDB48A2F79208E4C2FD1D620E514B4C233CE299129451BD2A
          8CF1C14958FD957B31A7F246B4F5EC42E347BF4434D583CC590BDDAFF72313B5
          3FE2F05B48E2E44513A0E32B697E44DCE5C009F92678A055A950CB6504220148
          211BB66615AC48C28CF23ADC38EE26ECECDA86F7CFEC819D7210FD7B3F8C8ECC
          671C329F248E8E4A808E2334CF13B78A31FA780F662D9989EA9A6A9C32BA104B
          457186A0FBD123E709C1C82461529162E8E9977B913A69B5F2D15C92B08A12A0
          F3F134CDC41411DEEB56D4A1A1F6667C12DF8F96D36FBB631CDB813560C13218
          978C03580EBC551E48AA3C2A2193BBE454532FDFC13A12F8C33002742E7E7F48
          4C9754606DE3CF5013A9C186030FBBABB5FA6D98CCA96D7039CE9018F25AABF4
          C0135446746E256DA44F9BE8793301A4D14A02F5C5082CA4D92AAE17DC7D0316
          D52FA1F387DCD5A67A4CB1B7B311E08ACD53368C6326EC01A0B441871292A157
          69451C5B30A3225A361207D3300EB991FF3D09FCA21801E17CA1C8F9EB1BB760
          4DEB9DE83FDD0F339E159A9D76D0D79642A6DB166213FB7A37312F58EF85364E
          816F820649CA4E992169339671576E1CCA906C26BF0086008B49604731027B68
          EAAE5F3E070DF31AF0D4814791ECCCD68FD4710B03EFBBD742C97FCA89F42CD1
          AD56C8C1D05C2FBCE3B833597BCCDE8CAB7C317B6F0B09F7D8CC9233B84B4460
          72426C2D24202AC8CC0737FD06EFC49BF1C9E707609C4C4372244445EE803E62
          1A5F3C31E49DBFD17CBBE2F6123735795D98A72CF4ED4D9190042520A174810E
          878F8D4E96EB7DEE420E719EA98504FE4373CDEF9E6EC493ED8FB80A4F74A45C
          D5C7B61862C88B7C69F990F16A6EABBE11BC4E8767AC8CD46719B717C076A7EE
          2622E1AF5323E1AC2B35A4A06F770AC976371F530A093C46734FC3BA793868ED
          77EF0D741AD9D5B4A485DA45C83F46B6045713DEEC1E0003EEE8B9108B28BD42
          BC407C8D7822FC0D12F049D09922D92FC3EAB5D1B5D9ADCAAB0A09CCA6D91559
          16809312B53C8DE4612ADD70CE0DE256572B65E65B85A74C664829B0236ED3D9
          40BC4AB4314A666EBEFB681E2EBDD90799544BAEF0E63580138FC7E0A4B1B158
          213AAE84A4CBACDE7C3E1DF8A668D027A82C89C3F7B74D69C4B727C5E5223ADE
          5A3097E88477972FE28BAA04FFE47313743D7F96EDDB7EA458211202ABD6AA15
          F8AF6675D3A5C1A2238A93EC9509AE4396B83DB9CDCE3888EF74F5714B61EFE7
          7CA2A236942FF6B16B01FE4943083C4702717B7D21810534DB83B334782FE78A
          352A38EF50A755CE0F58A2C3700B92D86AC836999D43E612A7A537659FE42FA5
          062446A06482D77D364DAFC5B6C67F89CBC64202A20F74942F09C07F850717FA
          248E19487751A0ADEEB6125D53286B3221BAE8B7088FBFD6032FD3273392BECB
          BCA82D9B89D258047FDDF09278E7C1621A381698A14D2C9BEF1FD5B9C34D9D38
          9A429A3BA4BFB5E0B023843A4686FF2A8DE785AC0B4F858A40851F9BAE7D16CB
          EF5B86787BBFB8FDCD62041E675D5F336E65081243AE480A9B9D358C80CDA293
          FC94A1A7169CB4ED5640E15812FD88F786D65885ABF7567BB176FAFD68DEB30D
          5B9FDA266E8B036B653102553447C2737DFED02C1D11BD125706A7E2BDEE77CE
          8F008B94D19576FB039CF3E710ED408857D164A8016AC7A7E07B937F8032A502
          3FBF779D38A289617FA666568E7420F93515FFDBAABB426EE55A36F14E04D400
          9E3DFCC7A2A9704C418253C98EEB5D4421DF942E2F198FD5537F825D47DFC5E6
          8D9BA97CD7B92856F52470602402253487F5C96A756469D0BDB7E9DAE710D64A
          F1C0076BD13970EC5C78E9CDABE8D0651D9AC2AE286B18C3A87D357C957B222A
          F594A1E91F2F60F72B7BB324B3C9BA95CE9BDD688D2432925841D314BEDE8750
          1DEB3C277EA6FE25D4965F83C53B6EC0F1DE4EC4DF4B32C48A2B34717A0A9505
          100E96424F94A0A3BD13B10E1EC14EB056F40D1EDDBA903DA2BF3A98AED1944E
          124D0CF08AC86D41F8267950A2FAF1D08C8DB8FF839FE2F39628CEBE9B1C9E12
          7EA5E1D3B623FB6FE9513A4F9CA7970B1010A96895344C1F7B4710DA58D5BD2F
          8E66A294E64F48FC3C41BC488C21C48156CFE5394AECA5D3EE917C5CF07F41EE
          68DEC62D160ACDD6D95034C476267840C9E48734D2C1AF2E34CF2513C891B889
          E635A2A4E0D193C41A12702E669E4B2690235147B31ED9301F46F66FF85F2ED5
          71FEF33F6833EB8E8BF5F8E80000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage19'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000089A4944415478DA
          B5967B6C14D71587CFBDB333FB5E7BBDB677D74FD64FCCCB2606037608949094
          36561B282A044423888841A9941228296A923FC22B228552D4000A20400DE084
          06882026108813626CC04020408C1FD878EDDDF59A5DAFBDEBD9D7ECCCED1D27
          5888A08A477CA591E671EF9CEF9E737EE75C044F38BAB66FCF335754342384C8
          E3AC478FBA8010826ECE9AB15535B9F54FA277C4362EF7E2726C084BEA82679E
          36151CAE1B720079B4EFB28A6CBE0B83182F111CC0088920DD1A772ADA98DA9F
          B5EEB3994306D0BC70E15446EB7B8D2BED9A8A92EA8D482D32831F435A00350F
          D05DBC2765D6A5854302D038AFF49C32A36902789324C5D46E2CF87C3B232D68
          3F44F01ADDDC58296608A0A8F584759A6BC69000B4AD2E392D5D6F9B06412330
          25815BC3DE76E5C8EF6F0070DC2A4558FD1C06E1427195ED6F75E54302D03477
          EE64D5F4EFBF8A560619F6055F4BE6B2BE3CF9FD658D2645BB58B0EB67C718A0
          6250C64D9F631A7DEA935F1CA065D9B3754CE4F2C4589D161465540F695D9B7D
          5BD95A76B862ADA9222117E9C3340F3C808392DEF26BE07F7100CFE6CD8660C2
          6A8FD42C62D1A90746CD31382F0A38920448CF013302FFC3F24CED5FEFCEEFAA
          4B34D3FA50286288A494DCF9E68901EE0EBA777DFB46935F3C6302B60CC590A5
          5F81F864607262872CCF5D9F7DFB6B50DA7E0561E7C1DC6BB1EBAA51382B40B3
          24EF8DB4974EFED3753E63A47582FDC64301F86F2EC8E71D553749440580E94E
          F5FAEB96B2D6D17231EAD83DF202F1B80B15E3E2DE64A5DCD3D8D85964F2DFD8
          EF62132E1029300609C9478573E877E049C238110314B58431A30D60C2264908
          9F4F9DD136F167006DD510CF61D0A74E818E0197DF98BE55B8ED5C0A61AA7101
          81686C86F8B4BF5B75235774F55C84B828D85680B7EDBDBBF1767E5D58098AAB
          73E4FBE81746204D66C09918709C02501C0358CDD150119012DA416A7A7E65FA
          6BFF797F10C05EAB4A5580EE7B907A8D98B37E2E463B9623925283FD962488D2
          1DC410489C07101BD78A127BAA445F6F05780D2C58F93E46C5E45B2679DC9D1F
          BCF13A1EBD793341129D4F3DB89F85E865C6CE249390F605452EA7C9C5885582
          A8A6FBFB6EE1ACF4B56B0F0F0038EA93F371145FA609A3211001224600C51209
          087108A8B2062EEA0122C580186E03F25A007A0D40C20488BA0F708133A24C5B
          6216DCEF2BC5B0D689943CD3BB9D93F823DC9CF1FDFDFF956D5C1DCFE519FFAC
          BEA6E0D2B9188905589BA3D03A29D03600D073EDD5ED61DFE10A8C3534D602C8
          1010D3D0AA160F20CA4917A5CFD40B3414847A437E84285D4A5507127D286A02
          EC9EF98994F2D11F0715305FB3BBD81E5C746F88DB776AF7B1306A1ED2894012
          ED40F8945D0300FEDAD365FDA179359895938DBE4232040F822B00FC315ADD5A
          313009B4C09488A0191F07A8DB4677AF009993247680D8350CD405F94704F5EE
          17C94F89E55EAC7E676C4368F5BD001D95F1BB185FFE22D0D139463F44DA05EF
          600E383E7CE916CA3B9D8531DD35E6813FEF06DF7A4E9442E803FAF938DDBF83
          FE7C94E637C29BF14B7121EE1C433D414360BB0381AD231B4DCBB2360AE17D1F
          12B58F0250FC638AF69CF762366A60E09CD0F925984843563BC6462D49ED2548
          1D46A133E68E0100670DA811CAD80821E552845910F8DB7407D4C93C33BD3810
          F8F67E79B66E62AA55D96953A12F1E449587B0D6D46398E197F5ACB3CDD3CE6F
          5981536F1A901CB17AC64E21B72A52400DB75396E3B05987E2A9E7B25DA26FBD
          F963C394293B90FBD2D875A2DBBB12493A0661252D183CF84FB5827F0BF7F6B8
          6070CD83EA83B30E0AC06FFA0175658314A409AAED0192E40085D1F08314BD33
          9CE6110689FA81F605F4938F85139900C1046012A924739D407AA6E7A7BDBAB7
          09B9BE2A68259D061B524A8038EA528D0F7C7B3BA0FF33766C09CF5F796025BC
          08ACD3678860770122113921E93B5100F4541B485E3541F14E6A97CA56D24B08
          050610883F832776ACA54AA3A593A36EFCEDCC611B361D418E53C3DDE8962119
          68FE21EA00D0F92050DD06811D9ADC62BFBFE541001DB590A308589AA1270348
          880112A3BAA7F980C67C07B193CB3F150D4767F2DF205FDCA21E3D637672F29A
          50D5F05EE49BB489A89A5791EECC3539FBF6AD1BA884AE93A31D922B98822234
          F938DA4D552208CC15F02CE7163F650FED7C60086AF02AE4CB5F07211D9000A5
          66FB81288240AC0E406756BEA5B4D90E99162C68EED8F4FC61A26F28A71F217C
          BC606DFE91E36F918E0E354A4F0F0DF602C796651F457CB5F3B951BDD438AD74
          DE0C804427842E7A82813D2A5B512BDF7DAFF1AE6F61028924D7203E43416871
          928CEDD4D95A106EC683704D0B5CF2B4D733DE7D778B3CD75B556510ECF6F1F2
          BD79CC985A545A1ABA7F33C87FF6AC95AFAF9FEBAFA999A85B523D1BD92D9800
          2D42E94D207406C23127FAB7628458C99A2151EC47E58CC2BC14472C0C91CF1E
          3280DA05FDC7CC3DE0C93D6E282BBBA0292DDD6F1837CE030F3906EBC09DAB93
          E7441B1B2AA1DD460F153485684E40420F809E5E4C0C90A4A55722205AA8086D
          F020FED81F88285188AE70EA0C97FA618D3E10C079D66A8F9D30A5CB52441A4C
          017E8440F26FA93A64850047934D45D35E3E0C4BCC407926920092CE0BE11DCF
          58B20F1C703F3EC0C1B99D22F93C955CCA1A689938AF8BB6502AE4F64C044A59
          211442491B8331DA27890A0326FD88082A2ADB76081D9940E28A16FC3EF1E597
          8F3E368063FDFA17A391331FB363CF7258A784E8B94260477825704918319440
          9668423708B74685A4AE9C2B8CB561125BDC08C183D9C0AA8AFF95B161C35F9E
          2804F2F0ECDD5BD27BEED017E1AB768DA6F8E9BDBAF26851D4FE65090A986828
          68BCF39A80DFF1ECB9BCCA4F27B9B76DABE83B73EA1D657AF6C1CCC734FE3300
          79F8AAAB8729785EAD2F2F6F08F65C2FEDAB9F7F9688F4C043B5213AB3E8C9EC
          0FF352972C3920CFA54733DA4350E8D1CDFE1F80FB47CB2BAF9C0C37369AE57B
          7576B63F6BCF9E29D4A8F424461F0960A8C7FF0046D3B2A8FAACF99200000000
          49454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage20'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000061E4944415478DA
          ED977B6C536518C69FEF74ED69D775B08D3148701A030A0114190AAC2D773660
          30640491BB0C0917414541C048A218130D825C04479820011505C3FDBAC9606D
          4108102E83381D7F106EE3B2B1B5653BA7A73D9FEF392BC9A44DDA3F8CFA0727
          59BFF59CF37EFD9DE779BFE76B19FEE3833D01780210ED64B2DDD28B439D46FF
          A683F1740696A8022A8D2A5570707EC3E7960B1EAFB3D9C51574FD95705D1AB8
          2050890ACE389D53E965A9DF2DAF8D0960B39BA7D104C519F6548C1F320915BE
          F3B878FB1C94DB21D496366855553E97DC21A2CE613E23589035626E2E063F9F
          872FAF2C85744FC283D246C8B782DA2DEF13F88A7800A610C077BD0BB37078AA
          071F9D9B87ED97BE87722F84FBBB1F6AB7FC4E13758A0430FD66B00A3D371415
          63F85305C8DAFB2CE4DB0AEACB25C83782DA87BDE375CBABE3B0C0348133B6B5
          FBE42E3836FD0C669C1C8FB2CA5228F743A86902A82080AE51003C8245C85E57
          B4168E8CFE185A92FD3700B2604E5C1624D94D631963DB3ABFDE0127DFBA8482
          B241B87CED2202A440CD9E875AD1797A92972201C4726662CE55EBBF4297946E
          98E21A45D287016E1200C74CBF475E1F1BC0691ACD38DBD1A1E0699C9D57893E
          075F407575B56E41CD5E4D0176D6E7967A440138CA8CACFFB2A2CFD12E31130B
          CECC864400DEE352530F70F6A6CF237D1BBB079CA69174F3AECC116D7061C155
          74DB9309B93640006A18809FF2B903BD22AC7388251030E8B3F59F2229C18665
          159F40BA19805753E056480378830036C7EE01A7984772EDCBC84DC1A90597E0
          3CD8154A4D48FF6B0280877AC011A19C433C4413E67E5CB40464218AFF5803E9
          4640B720402B88CE4DF2BAA4ADF100E412C0A1D401569C5A54810187BB235013
          44B0E69102384E00FDA258B08F86BC0FD77E00A3C1888D7FAE2300AD071A7500
          8A83717E57605B4C00ABD33C50E0BCB4651F0B5C8BCF6258A99D564090142080
          7D04C071D4E79107465A27EEA66BF9F357BD8B44532236557D83C6EB9A053202
          D5410D600C01EC88A309CD7D19E7C75A382C2859E4C6685A05010208DE2780FD
          0F69221CF1BBE4DC280AFC4243C1DB2B6621D9D2029BABD643BAAE59D00440D9
          32CAE70AEC8AA3092D7670D59D9C6DC6BE852598509E4F4B50B3807A60BF9E84
          072809F3229BD0FC33E5F498195F1422CDD60A5BAA36847B200C00E493757B63
          F740B6F1658AF1D3C93DCD58386D318A2A5712808260AD66810EB08700464680
          DB4D5BA8D3260E5F92032E8670B1F61C1A3580E332943B94841CC3BC1EF9606C
          051CE2733454DA7A98D16E606BF8833E04EE9202B56105809DD136A324A7B886
          3E64CE3333D3A15A435043AA9E03F5C70880EA058E9C7A8F5C12BB07B2935A33
          41B993D45D444AFF44FD5CE0AED2B40A0E345011DBEE754BAF4528E7342FE59C
          2F695BD802092902788837051101680FC0391BE0F748653101D019265B8A2827
          752380814D007235013C50514B001CEC47BF5B1A1F45B9F76858DE666A328CA9
          06F02001DC6E0620B0BEFE72A93C3640D3640DD6AE264B6A8E350C40163C08E9
          00B40EB750124E8EAC314FA56B1B332627C394DE0CA04CD2F7110882DD57DE78
          225E805B899D4D6DD386840168A2609DFA086013011446D4384DAFD21ADDD966
          A20DC68C04708543BEA3A0EE5749DF4919537B7A5DCAE97801AE247634754ACB
          6B06A05970B0410BA2620AA2E911BDE330F7A32F4C6519E34981B606A8041068
          06203035ABDEA59C8B0FC0693A91D85EEC9D961F06B81556800028E68BBC2E79
          D6E3355687F14501C2F9D6636D10DB254095B9BE7C1F01A850BB3D742B17E255
          E080A5BD7168AB9149FA7BAD9B35051E1C6AD092F06B4AC2B98FD7A4382C9941
          A8D7D2C7D860CED40054BDF974000A315A215DFC9EC0E5B80048CE1F2CCF248C
          4B1F9DA437936E81973F02584900F31EAF49ED8964C528D66B359A02419F8A90
          3F84BA5202A8D5B6637424EB2AE302A0BD7D9D9899302B65B0050A49CF042058
          4F0047F4205A4E41343F4A1923E51452CDC0ACF4054C6B7C93A06F609A7A828A
          F6F527E4AB7101B4B08B83210AB38D69825DB0B296212F37928C5E1E522B68AB
          5E4D52FE145539BB38C360408E9022743724306B803630AAB94AB255188CF282
          BA63A88B0B20E2180303B66BCFF4CF1EFFCF5F46FFE6F117DD2C504EA7FD4A91
          0000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage21'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000006884944415478DA
          ED970B50546514C7FF77EFDE7DB2C02EA88BA820282A609A285A6298DA683E40
          D392CAC9CC573EF3318E53368D8FB499DE36E30C5166242A68A26526DA68CE14
          8C64858A8682C48ABAAE2B2CB00BCBBEEEBD9D0B48281292344D33DD999DCBDC
          DDEFFBFFEE39FF73BE03238A22FECD8BF91FE03F07C070095DE936993E5320F2
          3F43284A1585EACA7F148044A3E99604514CD270FCF0717D6A64E3FB5623B330
          183F94E94C10EDEB215CD84B7BD5770A0009CAE996D0249A6CD47923A6F4B761
          CA001BC645D640CD09CDBFDD75A60BD61C09C70D077302E2AD7510CA7EA63D7D
          1D0620517FBA4D68129D38D0E8D427916012090FEB510B86697B13879BC5FAE3
          3DF1515E88DB27B8B743B8B20562A559BC8FF032908F94DEF6734EC63F9DD8DB
          A190DE54120ED7BB3B9CCF0B37D558FA75244E96E9CC84B519FCF97462A86B0F
          E029BDCAB5FF9D09C5983BCCD161D17B5D99E782B1FADB7098ED6C1EC40A4A4B
          692E8178DB02D83A31EAFAF2E71E32C15AA7C5EC38270CEA072FCD5A8F0C1B8E
          F7C2D65CA3CF2B78774228DF441E31DD9D1609207FE398B3F11186DA86070E37
          8758238B847057A744A3C8AAC6B24311385EAA3904FEF41A7A54420CCD2E9600
          4E2E197E29F1919E15CD8B2446A7CF0FF38792F9640F0650E53F0839F6C7F1FC
          BADC13A2EFF40A7A74B1653A24808C2121B6E7578D2C6AB5F8569D0A4F3DE441
          2F7FA1239A10695B5B8F6498FAADC44DFD28980A0AB064E6E253E0F317D0D7C5
          04D0EC700960960CE2CEA763AF6072FFEBB8BBDAEA5906C65E324C0EE4DB15E6
          E57EB0F599034BD462B8FD22E09571705147A8B87A15CF24A698C017A6903BCE
          B56C58120047F797E8933A70D2652CD259E1EF6B6DC2AA6016F34279A8EE9112
          B7A6272AFB2F85352C054E170F9653401B1402AFC0C04DDC1E4735968D4DC039
          4B801962D55A0817B309C2D9002099929AD07C043BD390741901354A2C0AA841
          ACBD75D554A96578A2B70AFD940D6B51AD8F87A5EF525418460182175A5D4083
          8104DE0BFF2EA1E0E93D6C9652980E6C4656D6F738566C14888FCE8F2BAF41B4
          9C21EDCADB00B918667E14031B8DC838594CD17A31DD5E07F6AE60882C8788F8
          24B86316A0CECA43D1AD2BFC427A80F13941D982BF21089C4A05F3B53C9CCA79
          037B5C6771A65607F1CB6E40B9D202D1F63A844B5F916E45CB085C42DC8D280C
          BAF5A712F92E8A4A7289AC1A41EE1626E4B490CDF81A01E93BA0CCCE009FBA0B
          AAF811080CEA42703E94947C83EF7237E3A0CA0AAB8A6D5C020586F02391BFF6
          3AE0858BDAF42B047188BEB2DC064885BE7E21A695B40ABBD6AEC4027F3BE2EC
          9E46A31947409E9C0EC3A615509C3802BC9D06F7936371AE7837722E6C436E80
          175EB6D1CA5D145D3137661E9EEDFB222CA595189F309B87F0DB6310ABAF49E2
          A4EDB90D309E827B18C3CD2C62EE71B4D361F304C7639693721F3503B231EF42
          BF6D23BCD5D751E65F890F8616E3AA966DFE79AC3E168B635FC6F4C8A990310A
          3223A9DDA8C490E8A91459EB6C082539A46B6D4E41C31F5CC228325026C2ECDD
          31EA2AA06C5DFBE14E155619BAC132FE3DDC3CBA01BB7B17C1681551162AA772
          62F078C8582C8C5E88A17E3134AB78A0D71BC02A55F0D156B54E17C207D0096F
          53515DB852C117BD498560B9631E2088608248879F6F22465F01BA395B41A81C
          1CDCD11C447D635F50B16A4CEC3E032F44CC4198C2004E2690B01E6A95026A05
          27590955F65AECCBCBC6CAB457811F7B50BF97068AFA6DE00B3E6C3590108494
          C0D514AB2D88BBC9DD61CCA64BCE2811193318F1BDC7605A680A82650C147206
          7EBA402858812044E8344AD438EC48FB2E1D1F7EB103EE421DD5AD54BF9E8310
          2C1910AF5DA0AD2ADA1CC908643845230BA17561482C07D4770E39CB13DFC784
          C8D1E0E47228B50150C20325274168515E6E42DAB79F2233EB28501A08F840F3
          41FD1E08A67D64400A2D2A6F9F077F3913124420417C46E2D31A20421B670B95
          5C83CF669E845A6D808695845968D41A9CBF5888ED073E41EE91423A4834E46B
          BE00A223834A8ECAC52799AEAAE549D82E400B90251084F731B84281382BC282
          06E09D497BA0A01C33D4980A7EC9C7CECCED28FDC942FEA26600EF316A38245C
          7A4A0A3369B439E9DCF7584E100F5334F63246571F5DB21D6F251FC6AF3FE6E3
          4056066CA50DB3440DA9EF8360DE4D6DB6B829CCED0E151DFABF8020A8A78A1F
          53893EAB502BE0A9A14A108532A08E5AE2EFD9546CE626E1F68FCEBF03D00264
          2E09CF2443EDA793ED045148A552733F5370A700342F6618B6236FDBE9009D71
          FD01F5701C24244AC9A50000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage22'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000009194944415478DA
          AD97077414D71586FFEDD2AEB4ABBAEA0535BAC0221463C008C72896410EC774
          08D8C6067C08871088902302C2E2D0621C4C49C0F4C854058305D89812644080
          502F2009A1DE7BDD5D6D9999DC5921228905E21CBF73FEBD73DE7B33F7DBFBEE
          BCFB468057B48911CB4464E691DE253591AA49B748C9B7130E185F75FFAB9AE0
          7F00384566AE85A14ED24FA4EBBC0826F7170720E7216452E5D65682CFD72DC5
          E0405FB4B677A0B0B8C2ACDCFC22643F2A02C771FCF45AD20DD235D265026AFC
          2500AE90095BF1E14C8C193F1165F57A302C072BA9108EB662382B2580498B5B
          F7D27133291D590F0B7B6018D21DD279D2058229FBD900E47C0299DBDE1E2ED8
          B2290AF9F50C5A8C62B0D4290207FE4ACCB1900A3938298470221831BA90929A
          D11F866F194F61CEF75FAA9701C49159B863C34A481DFD90D72A78E174210149
          78209242CCC15D25865CDC85CC8C2C4B304709E2A39702907325991A3F1F77F9
          BEBFAE4772990135DA57E6EB7F1B39930A0846C4C1D79EA2233720F1760A0E9D
          484097DE004D7BF388F4C4F8EC97017C42E6EB554BE760F2A489B85EC2C0C43E
          7D365AE84704814049D7C5D47F0F75256EA8286C84CAC9053E41C15028ED7BD3
          C045C6E2D783E558BD6117D2B2F29173EFF2CCD686CAEF68D0F422807B52A964
          DCB747B6A3A25382CCBA6EEF2C97871B55A114F256B45CB542EEAD2E34554A30
          C8DF198302ED515ADE8ECC9C0608644E183A261473576D86CAD1057E2A0EE37C
          65786F71249A9A5B1AEF5E3ECC2FC1BF491A8105E783C8E485858E43E4CAC548
          2C36A24ED349697D00198DB138785707D95920C4C91B5B368E87EF000F7431D6
          94A00C5412016C2506D4D5B720765B1212AED662FEEAADD8B2E66334D757E193
          355BF9F05FA1F0EF231F572C468000B69389DCB76D2DBC7DFD7029DF40B36261
          C2163CA1553BBE5E82752BDEC0AC3963F19891A19535C0C0EA28D0DD4926135A
          412910204864445A4A3596AD4CC07BBF5D88B193A7E1D8E9CBA82E79B8B928E7
          CE8FE87E4DFBE600391792A9F4F172738BDBBB11593526E4D63130729130B2BB
          113307D8BF2502BE2346A058684417ABB59883465AB1DC060966BBF941DE918B
          D7DE388837DF59008D496648B97E72815ED7C927E0634B0013C9DC5A323F028B
          E684E31139AF6A67D1AAABC43FE3C6C3BDC11991D1D390C55154B81797814E03
          50D426853BBB1C93D5579078E932D66EB88DA163C3B3D213CFFE05DDB5A4CD12
          C02E32ABE2F6C5C0C7D3F559BF46AB45E8A4E1B870321C7BAA6C51ACD560B40B
          E0696BF935AAD3F04FF680A26B11ECC4ED18A5FC1A73179E4441992885B23F1A
          DDDB352C019451F8BDF9F0F76EC9C9C9387E701956FEF103DCEED421BDBD160D
          3ABA99EE968B017B2B6000ED1C6E8AEEF067D40393BDFC21D6CD45A7CE00A6E1
          22CA52CE203AF6EE03C6645C4A8FCC7A0E809C8F26F360F1EC702C5910D10720
          3E3E1EAD350731FE9DDFD31E330A25D99750EC5903B9510217F741A86E2A82C1
          D40883548F5AFAF7EE36D6787BC012945729D1A1EDC2C3AC6B98A8BEC185CD38
          5D408F9B42AAB104B08DCCBA23BBA21130C0AB0FC0CE9D3BF1E6A80CD806AE83
          441680CC4387C1B12C1C070F425B4929ECFCFDE0161202A9BD1246A60D32B1A3
          F9BED4FC2AD43434A1203F132BA6A473434376B7300CE7C2BF7E96001EBBBB3A
          059E3EB0F9B9358D8A8AC2BCE9D55005458315FA2075EF5E88ADACE13E6634D4
          C1C1746DF5DC3D0613838CC21A2AD9C568AC2DC69AF0746EF0C8BF9B0C467A77
          01AE0F00391F4E267BDE8CA918F7B61754562AF83A044028109A279D3B770E9D
          0D87307CC28768CA90A0F949217C42A7C07DF4AF5EF826B46BF4C82B6FC0CD3B
          69B015D7306FF924B16111DFE4D0D0A8DEF37A0062C86C3CF045143EBA1286CA
          B63228A43618E2128CE1AEAFC1571E88EC53073167D6549425DA53F20911F2E9
          72486D6C2C3AE7FFDEC3927A54D737E36E6A0E06A94B3B45553FD8AC5D7F7307
          BFCC960072D44EF6C3B6EFF80093FF31C2E2435D7F54E2F2B199488E57A34DEE
          0845D868B8293DE162E30A9150FC6C1E43B9F1A4B219AD9A2E3C29A9C0A38705
          F878CA23E3EE9D1724DF261486D294C43E00E43C886CC1ACE953200FAE43CCD5
          3F5904105F1462E1A460CC9B198293B976A8B4EF32F78B8422A80942ADF0848D
          C01542C60E0A89CA0C95F42013430A1330CDBB98F18DBCA9319A58C7DE09D803
          C08764DBDEAD6BB13F3F06171FFDCB7258190E6D2758FCB0E77DB450D25D68B4
          0623B0066B94C268206B9050E8BB737A00E54FB07A246C8F6E40C491D3542044
          981D688BF89CD6E5347CA03FC019B2B3BF3FF93734E8AB7022FD3032AB53905B
          9B098DA1B30F04ABE3203C2FC157D16F2178A42BBEA284ACD2AA201629CCABC9
          1724A35183E9032740CDE6E0DD142D84C74FD0995A09D6478181EB53D92755BA
          8534F9546F806364174F9B3A010BDF0F83BBAB73B7333AEF3D692CA082948A8C
          AA146455A722AF3E17BA463D5ABE3362DED82188F9EC7570620532CA5994D306
          E46C25A47F6F0D67850E67CEA621ED7436CE6CFA9493BCEE2BC0F59330D021D2
          E30FF7D9C636D30C7271A9076018CBB2B78542A11DDFE14587D081FEDE241F0C
          0CF046A09F1714726B339491315081CA3147E8D2D58BB87EE427B8086518399C
          0E24410E282D6B331F483A3472E861038341AF87B64C567CFF4B938D5422C6D5
          136811318CC78AFB469D9EE50B5FAA79D1FC868D0F7770F1F94C2AB30E108925
          AEFDD7DFD34D8DA000EF67603C94AD8DDC3C56595781EF932E22299D0A9C82C3
          9FE7C7A0BCB403B15F1E81B6A3E55ADACDB3B5748CFF5DD1DD58BDBB83930CD7
          BE415C513D16ED28D849B7AFEDD909F91D87FF0871B35139D93A7B06F8930DB0
          92DB0648A46628757F28DA359F4589B741FE3C94025ADAFB576FDC85BCC7A5FC
          E123960E1FFCC74AA05088FD77CEAD66C6FAD44936EEB923D87CB43C8AFAB7F7
          AE86FC359F002A92DD5399F7585B7BB5D2D9DD3F808792F1507CA44462A7FE50
          6E6A4768755D68EBD0C0A8D715DCBF1A1749D5AB9086F248FC1EF08558240831
          311CFF6DF01B52D5ABCEDA56FD807849F901A583AB8AA002152AC70099B54D0F
          94837933624CCDA58F92375597E416A3FBFBB1A3D79FE4AB6E2A9FE73D1D3FB7
          59F782E98193F003764E1EF60AA5A34343755185A14B43E722F09F64D92F7BD8
          FF0360A929FA01F115AF81948F7E3B5FFFF61F7F5BCA4E5C86702F0000000049
          454E44AE426082}
      end>
    PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    Left = 160
    Top = 8
    Bitmap = {}
  end
end
