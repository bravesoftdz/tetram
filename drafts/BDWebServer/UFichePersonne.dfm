object FichePersonne: TFichePersonne
  OldCreateOrder = False
  OnCreate = WebPageModuleCreate
  OnDestroy = WebPageModuleDestroy
  PageProducer = PageProducer
  OnBeforeDispatchPage = WebPageModuleBeforeDispatchPage
  OnAfterDispatchPage = WebPageModuleAfterDispatchPage
  Left = 897
  Top = 258
  Height = 150
  Width = 215
  object PageProducer: TPageProducer
    HTMLFile = 'WebServer\FichePersonne.html'
    ScriptEngine = 'JScript'
    Left = 48
    Top = 8
  end
  object Albums: TPagedAdapter
    OnGetRecordIndex = AlbumsGetRecordIndex
    OnGetRecordCount = AlbumsGetRecordCount
    OnGetFirstRecord = AlbumsGetFirstRecord
    OnGetNextRecord = AlbumsGetNextRecord
    Left = 128
    Top = 56
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object RefAlbum: TAdapterField
        OnGetValue = RefAlbumGetValue
        ReadOnly = True
      end
      object TitreAlbum: TAdapterField
        OnGetValue = TitreAlbumGetValue
        OnGetDisplayText = TitreAlbumGetDisplayText
        ReadOnly = True
      end
      object HorsSerie: TAdapterBooleanField
        OnGetValue = HorsSerieGetValue
        ReadOnly = True
      end
      object Integrale: TAdapterBooleanField
        OnGetValue = IntegraleGetValue
        ReadOnly = True
      end
      object Tome: TAdapterField
        OnGetValue = TomeGetValue
        OnGetDisplayText = TomeGetDisplayText
        ReadOnly = True
      end
      object RefSerie: TAdapterField
        OnGetValue = RefSerieGetValue
        ReadOnly = True
      end
      object TitreSerie: TAdapterField
        OnGetValue = TitreSerieGetValue
        OnGetDisplayText = TitreSerieGetDisplayText
        ReadOnly = True
      end
      object Libelle: TAdapterField
        OnGetDisplayText = LibelleGetDisplayText
      end
      object IsScenariste: TAdapterBooleanField
        OnGetValue = IsScenaristeGetValue
        ReadOnly = True
      end
      object IsDessinateur: TAdapterBooleanField
        OnGetValue = IsDessinateurGetValue
        ReadOnly = True
      end
      object IsColoriste: TAdapterBooleanField
        OnGetValue = IsColoristeGetValue
      end
    end
  end
  object Personne: TAdapter
    Left = 48
    Top = 56
    object TAdapterActions
    end
    object TAdapterFields
      object RefPersonne: TAdapterField
        OnGetValue = RefPersonneGetValue
        ReadOnly = True
      end
      object Nom: TAdapterField
        OnGetValue = NomGetValue
        OnGetDisplayText = NomGetDisplayText
        ReadOnly = True
      end
      object Biographie: TAdapterMemoField
        OnGetValue = BiographieGetValue
      end
      object SiteWeb: TAdapterField
        OnGetValue = SiteWebGetValue
        OnGetDisplayText = SiteWebGetDisplayText
      end
    end
  end
end
