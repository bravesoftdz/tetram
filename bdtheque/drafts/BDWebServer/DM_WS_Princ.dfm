object WS_DMPrinc: TWS_DMPrinc
  OldCreateOrder = False
  OnCreate = WebAppDataModuleCreate
  AppServices = WebAppComponents
  Left = 393
  Top = 443
  Height = 283
  Width = 215
  object WebAppComponents: TWebAppComponents
    PageDispatcher = PageDispatcher
    AdapterDispatcher = AdapterDispatcher
    ApplicationAdapter = ApplicationAdapter
    Left = 48
    Top = 8
  end
  object ApplicationAdapter: TApplicationAdapter
    Left = 48
    Top = 56
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object Copyright: TAdapterField
        OnGetValue = CopyrightGetValue
      end
      object Title: TAdapterApplicationTitleField
      end
      object Version: TAdapterField
        OnGetValue = VersionGetValue
      end
      object WSVersion: TAdapterField
        OnGetValue = VersionGetValue
      end
    end
  end
  object PageDispatcher: TPageDispatcher
    DefaultPage = 'Acceuil'
    OnPageNotFound = PageDispatcherPageNotFound
    Left = 48
    Top = 112
  end
  object AdapterDispatcher: TAdapterDispatcher
    Left = 48
    Top = 160
  end
  object PageProducer: TPageProducer
    HTMLFile = 'WebServer/FicheSupport.html'
    ScriptEngine = 'JScript'
    Left = 144
    Top = 112
  end
end
