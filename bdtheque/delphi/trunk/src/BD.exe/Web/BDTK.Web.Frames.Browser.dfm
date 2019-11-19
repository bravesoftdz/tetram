object frameBDTKWebBrowser: TframeBDTKWebBrowser
  Left = 0
  Top = 0
  Width = 876
  Height = 576
  TabOrder = 0
  object Bevel1: TBevel
    Left = 0
    Top = 31
    Width = 876
    Height = 3
    Align = alTop
    Shape = bsBottomLine
  end
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 876
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object pnlButtons: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 31
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object btnReload: TButton
        AlignWithMargins = True
        Left = 65
        Top = 3
        Width = 25
        Height = 25
        Action = actReload
        Align = alLeft
        TabOrder = 0
      end
      object btnForward: TButton
        AlignWithMargins = True
        Left = 34
        Top = 3
        Width = 25
        Height = 25
        Action = actForward
        Align = alLeft
        TabOrder = 1
      end
      object btnBack: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 25
        Height = 25
        Action = actBack
        Align = alLeft
        TabOrder = 2
      end
    end
    object pnlUrl: TPanel
      Left = 93
      Top = 0
      Width = 783
      Height = 31
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object edUrl: TEdit
        AlignWithMargins = True
        Left = 3
        Top = 5
        Width = 777
        Height = 22
        Margins.Top = 5
        Margins.Bottom = 4
        Align = alClient
        TabOrder = 0
        Text = 'edUrl'
        OnKeyUp = edUrlKeyUp
        ExplicitHeight = 21
      end
    end
  end
  object Browser: TPanel
    Left = 0
    Top = 34
    Width = 876
    Height = 521
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitHeight = 542
    object Splitter: TSplitter
      Left = 773
      Top = 0
      Height = 521
      Align = alRight
      Visible = False
      ExplicitLeft = 608
      ExplicitTop = 96
      ExplicitHeight = 100
    end
    object DevTools: TCEFWindowParent
      Left = 776
      Top = 0
      Width = 100
      Height = 521
      Align = alRight
      Color = clWhite
      TabOrder = 0
      Visible = False
      ExplicitHeight = 542
    end
    object WindowParent: TCEFWindowParent
      Left = 0
      Top = 0
      Width = 773
      Height = 521
      Align = alClient
      Color = clWhite
      TabOrder = 1
      ExplicitHeight = 542
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 555
    Width = 876
    Height = 21
    Panels = <>
    SimplePanel = True
    SizeGrip = False
    ExplicitLeft = 93
    ExplicitTop = 521
    ExplicitWidth = 748
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 152
    Top = 64
    object actBack: TAction
      Caption = '<<'
      OnExecute = actBackExecute
    end
    object actForward: TAction
      Caption = '>>'
      OnExecute = actForwardExecute
    end
    object actReload: TAction
      Caption = '@'
      OnExecute = actReloadExecute
    end
    object actToggleDevTools: TAction
      Caption = 'Afficher les outils de d'#233'veloppement'
      OnExecute = actToggleDevToolsExecute
    end
    object actToggleAudio: TAction
      Caption = 'actToggleAudio'
      OnExecute = actToggleAudioExecute
    end
  end
  object Chromium: TChromium
    OnProcessMessageReceived = ChromiumProcessMessageReceived
    OnLoadStart = ChromiumLoadStart
    OnLoadEnd = ChromiumLoadEnd
    OnLoadError = ChromiumLoadError
    OnBeforeContextMenu = ChromiumBeforeContextMenu
    OnContextMenuCommand = ChromiumContextMenuCommand
    OnKeyEvent = ChromiumKeyEvent
    OnAddressChange = ChromiumAddressChange
    OnBeforePopup = ChromiumBeforePopup
    OnAfterCreated = ChromiumAfterCreated
    OnClose = ChromiumClose
    OnOpenUrlFromTab = ChromiumOpenUrlFromTab
    Left = 120
    Top = 168
  end
end
