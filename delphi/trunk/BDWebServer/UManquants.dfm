object Manquants: TManquants
  OldCreateOrder = False
  OnCreate = WebPageModuleCreate
  PageProducer = PageProducer
  OnBeforeDispatchPage = WebPageModuleBeforeDispatchPage
  OnAfterDispatchPage = WebPageModuleAfterDispatchPage
  Left = 900
  Top = 202
  Height = 150
  Width = 215
  object PageProducer: TPageProducer
    HTMLFile = 'WebServer\repertoire.html'
    ScriptEngine = 'JScript'
    Left = 48
    Top = 8
  end
  object Albums: TPagedAdapter
    OnGetRecordIndex = AlbumsGetRecordIndex
    OnGetRecordCount = AlbumsGetRecordCount
    OnGetFirstRecord = AlbumsGetFirstRecord
    OnGetNextRecord = AlbumsGetNextRecord
    Left = 48
    Top = 64
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object RefSerie: TAdapterField
        OnGetValue = RefSerieGetValue
      end
      object Tome: TAdapterField
        OnGetValue = TomeGetValue
        OnGetDisplayText = TomeGetDisplayText
      end
      object TitreSerie: TAdapterField
        OnGetValue = TitreSerieGetValue
        OnGetDisplayText = TitreSerieGetDisplayText
      end
      object Libelle: TAdapterField
        OnGetDisplayText = LibelleGetDisplayText
      end
      object LibelleCourt: TAdapterField
        OnGetDisplayText = LibelleCourtGetDisplayText
      end
      object Numeros: TAdapterField
        OnGetValue = NumerosGetValue
        OnGetDisplayText = NumerosGetDisplayText
      end
    end
  end
end
