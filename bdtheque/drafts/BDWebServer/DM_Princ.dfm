object DMPrinc: TDMPrinc
  OldCreateOrder = False
  OnCreate = WebAppDataModuleCreate
  AppServices = WebAppComponents
  Left = 652
  Top = 121
  Height = 283
  Width = 215
  object WebAppComponents: TWebAppComponents
    PageDispatcher = PageDispatcher
    AdapterDispatcher = AdapterDispatcher
    ApplicationAdapter = ApplicationAdapter
    EndUserAdapter = EndUserAdapter
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
        OnGetValue = WSVersionGetValue
      end
    end
  end
  object EndUserAdapter: TEndUserAdapter
    Left = 48
    Top = 104
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
    end
  end
  object PageDispatcher: TPageDispatcher
    DefaultPage = 'Acceuil'
    OnPageNotFound = PageDispatcherPageNotFound
    Left = 48
    Top = 152
  end
  object AdapterDispatcher: TAdapterDispatcher
    Left = 48
    Top = 200
  end
  object PageProducer: TPageProducer
    HTMLFile = 'WebServer/FicheSupport.html'
    ScriptEngine = 'JScript'
    Left = 144
    Top = 152
  end
end
