object DMPrinc: TDMPrinc
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 510
  Top = 202
  Height = 444
  Width = 572
  object UIBDataBase: TJvUIBDataBase
    Params.Strings = (
      'sql_dialect=3'
      'lc_ctype=NONE'
      'user_name='
      'password=')
    DatabaseName = 'G:\Programmation\MEDIA.KIT\BDth'#232'que 1.0\BD.GDB'
    LibraryName = 'fbembed.dll'
    Left = 32
    Top = 16
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    OnMessage = ApplicationEvents1Message
    OnMinimize = ApplicationEvents1Minimize
    OnRestore = ApplicationEvents1Restore
    Left = 136
    Top = 16
  end
  object HTTPServer: TIdHTTPServer
    OnStatus = HTTPServerStatus
    Bindings = <>
    CommandHandlers = <>
    CommandHandlersEnabled = False
    DefaultPort = 1024
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = HTTPServerConnect
    OnExecute = HTTPServerExecute
    OnDisconnect = HTTPServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    AutoStartSession = True
    SessionState = True
    SessionTimeOut = 1200000
    OnCommandOther = HTTPServerCommandOther
    OnCommandGet = HTTPServerCommandGet
    Left = 32
    Top = 104
  end
  object UIBBackup: TJvUIBBackup
    LibraryName = 'fbembed.dll'
    Left = 32
    Top = 184
  end
  object UIBRestore: TJvUIBRestore
    LibraryName = 'fbembed.dll'
    Options = [roReplace, roCreateNewDB]
    Left = 136
    Top = 184
  end
  object TrayIcon: TTrayIcon
    IconID = 1
    OnDblClick = TrayIconDblClick
    OnMouseUp = TrayIconMouseUp
    Active = False
    Left = 240
    Top = 104
  end
  object PopupMenu: TPopupMenu
    Left = 328
    Top = 104
    object Afficher1: TMenuItem
      Caption = 'Afficher'
      Default = True
      OnClick = Afficher1Click
    end
    object WebServer1: TMenuItem
      Caption = 'WebServer'
      object Dmarrer1: TMenuItem
        Action = Fond.ActiveWebServer
      end
      object DchargerISAPI1: TMenuItem
        Action = Fond.AllerVersWebServer
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Apropos1: TMenuItem
      Caption = 'A propos...'
      object Apropos2: TMenuItem
        Action = Fond.AideAbout
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Cheminbase1: TMenuItem
        Action = Fond.CheminBase
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Quitter1: TMenuItem
      Action = Fond.Quitter
    end
  end
  object ISAPIRunner: TidISAPIRunner
    Server = HTTPServer
    ServerAdmin = 'admin@server'
    Left = 136
    Top = 96
  end
end
