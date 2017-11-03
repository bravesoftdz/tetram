object Repertoire: TRepertoire
  OldCreateOrder = False
  OnCreate = WebPageModuleCreate
  OnDestroy = WebPageModuleDestroy
  PageProducer = PageProducer
  OnBeforeDispatchPage = WebPageModuleBeforeDispatchPage
  OnAfterDispatchPage = WebPageModuleAfterDispatchPage
  Left = 900
  Top = 202
  Height = 145
  Width = 223
  object PageProducer: TPageProducer
    HTMLFile = 'WebServer\repertoire.html'
    ScriptEngine = 'JScript'
    Left = 48
    Top = 8
  end
  object Initiales: TPagedAdapter
    OnGetRecordIndex = InitialesGetRecordIndex
    OnGetRecordCount = InitialesGetRecordCount
    OnGetFirstRecord = InitialesGetFirstRecord
    OnGetNextRecord = InitialesGetNextRecord
    Left = 48
    Top = 64
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object Initiale: TAdapterField
        OnGetValue = InitialeGetValue
        OnGetDisplayText = InitialeGetDisplayText
      end
      object Count: TAdapterField
        OnGetValue = CountGetValue
      end
      object UsedGroupBy: TAdapterField
        OnGetValue = UsedGroupByGetValue
        OnGetDisplayText = UsedGroupByGetDisplayText
      end
    end
  end
  object Albums: TPagedAdapter
    OnGetRecordIndex = AlbumsGetRecordIndex
    OnGetRecordCount = AlbumsGetRecordCount
    OnGetFirstRecord = AlbumsGetFirstRecord
    OnGetNextRecord = AlbumsGetNextRecord
    Left = 136
    Top = 64
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object RefAlbum: TAdapterField
        OnGetValue = RefAlbumGetValue
      end
      object TitreAlbum: TAdapterField
        OnGetValue = TitreAlbumGetValue
        OnGetDisplayText = TitreAlbumGetDisplayText
      end
      object HorsSerie: TAdapterBooleanField
        OnGetValue = HorsSerieGetValue
      end
      object Integrale: TAdapterBooleanField
        OnGetValue = IntegraleGetValue
      end
      object Tome: TAdapterField
        OnGetValue = TomeGetValue
        OnGetDisplayText = TomeGetDisplayText
      end
      object RefSerie: TAdapterField
        OnGetValue = RefSerieGetValue
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
    end
  end
end
