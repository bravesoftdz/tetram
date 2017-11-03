object FicheSerie: TFicheSerie
  OldCreateOrder = False
  OnCreate = WebPageModuleCreate
  PageProducer = PageProducer
  OnBeforeDispatchPage = WebPageModuleBeforeDispatchPage
  OnAfterDispatchPage = WebPageModuleAfterDispatchPage
  Left = 691
  Top = 210
  Height = 225
  Width = 333
  object PageProducer: TPageProducer
    HTMLFile = 'WebServer/FicheSerie.html'
    ScriptEngine = 'JScript'
    Left = 48
    Top = 8
  end
  object Serie: TAdapter
    Left = 48
    Top = 64
    object TAdapterActions
    end
    object TAdapterFields
      object RefSerie: TAdapterField
        OnGetValue = RefSerieGetValue
        ReadOnly = True
      end
      object TitreSerie: TAdapterField
        OnGetValue = TitreSerieGetValue
        OnGetDisplayText = TitreSerieGetDisplayText
        ReadOnly = True
      end
      object Terminee: TAdapterField
        OnGetValue = TermineeGetValue
        ReadOnly = True
      end
      object HistoireSerie: TAdapterMemoField
        OnGetValue = HistoireSerieGetValue
        FieldName = 'Histoire'
      end
      object NotesSerie: TAdapterMemoField
        OnGetValue = NotesSerieGetValue
        FieldName = 'Notes'
      end
      object SerieSiteWeb: TAdapterField
        FieldName = 'SiteWeb'
        OnGetValue = SerieSiteWebGetValue
        OnGetDisplayText = SerieSiteWebGetDisplayText
      end
    end
  end
  object Albums: TPagedAdapter
    OnGetRecordIndex = AlbumsGetRecordIndex
    OnGetRecordCount = AlbumsGetRecordCount
    OnGetFirstRecord = AlbumsGetFirstRecord
    OnGetNextRecord = AlbumsGetNextRecord
    Left = 136
    Top = 8
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
      object TomeDebut: TAdapterField
        OnGetValue = TomeDebutGetValue
        OnGetDisplayText = TomeDebutGetDisplayText
      end
      object TomeFin: TAdapterField
        OnGetValue = TomeFinGetValue
        OnGetDisplayText = TomeFinGetDisplayText
      end
      object Libelle: TAdapterField
        OnGetDisplayText = LibelleGetDisplayText
      end
    end
  end
  object Genres: TPagedAdapter
    OnGetRecordIndex = GenresGetRecordIndex
    OnGetRecordCount = GenresGetRecordCount
    OnGetFirstRecord = GenresGetFirstRecord
    OnGetNextRecord = GenresGetNextRecord
    Left = 136
    Top = 64
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object Genre: TAdapterField
        OnGetValue = GenreGetValue
        OnGetDisplayText = GenreGetDisplayText
        ReadOnly = True
      end
    end
  end
  object Editeur: TAdapter
    Left = 216
    Top = 64
    object TAdapterActions
    end
    object TAdapterFields
      object RefEditeur: TAdapterField
        OnGetValue = RefEditeurGetValue
        ReadOnly = True
      end
      object NomEditeur: TAdapterField
        OnGetValue = NomEditeurGetValue
        OnGetDisplayText = NomEditeurGetDisplayText
        ReadOnly = True
      end
      object EditeurSiteWeb: TAdapterField
        FieldName = 'SiteWeb'
        OnGetValue = EditeurSiteWebGetValue
        OnGetDisplayText = EditeurSiteWebGetDisplayText
        ReadOnly = True
      end
    end
  end
  object Collection: TAdapter
    Left = 272
    Top = 64
    object TAdapterActions
    end
    object TAdapterFields
      object RefCollection: TAdapterField
        OnGetValue = RefCollectionGetValue
        ReadOnly = True
      end
      object NomCollection: TAdapterField
        OnGetValue = NomCollectionGetValue
        OnGetDisplayText = NomCollectionGetDisplayText
        ReadOnly = True
      end
    end
  end
  object Scenaristes: TPagedAdapter
    OnGetRecordIndex = ScenaristesGetRecordIndex
    OnGetRecordCount = ScenaristesGetRecordCount
    OnGetFirstRecord = ScenaristesGetFirstRecord
    OnGetNextRecord = ScenaristesGetNextRecord
    Left = 136
    Top = 128
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object ScenaristeRefPersonne: TAdapterField
        FieldName = 'RefPersonne'
        OnGetDisplayText = ScenaristeRefPersonneGetDisplayText
        ReadOnly = True
      end
      object ScenaristesNom: TAdapterField
        FieldName = 'Nom'
        OnGetValue = ScenaristesNomGetValue
        OnGetDisplayText = ScenaristesNomGetDisplayText
        ReadOnly = True
      end
    end
  end
  object Dessinateurs: TPagedAdapter
    OnGetRecordIndex = DessinateursGetRecordIndex
    OnGetRecordCount = DessinateursGetRecordCount
    OnGetFirstRecord = DessinateursGetFirstRecord
    OnGetNextRecord = DessinateursGetNextRecord
    Left = 200
    Top = 128
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object DessinateurRefPersonne: TAdapterField
        FieldName = 'RefPersonne'
        OnGetDisplayText = DessinateurRefPersonneGetDisplayText
        ReadOnly = True
      end
      object DessinateurNom: TAdapterField
        FieldName = 'Nom'
        OnGetValue = DessinateurNomGetValue
        OnGetDisplayText = DessinateurNomGetDisplayText
        ReadOnly = True
      end
    end
  end
  object Coloristes: TPagedAdapter
    OnGetRecordIndex = ColoristesGetRecordIndex
    OnGetRecordCount = ColoristesGetRecordCount
    OnGetFirstRecord = ColoristesGetFirstRecord
    OnGetNextRecord = ColoristesGetNextRecord
    Left = 264
    Top = 128
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object ColoristeRefPersonne: TAdapterField
        FieldName = 'RefPersonne'
        OnGetDisplayText = ColoristeRefPersonneGetDisplayText
      end
      object ColoristeNom: TAdapterField
        FieldName = 'Nom'
        OnGetValue = ColoristeNomGetValue
        OnGetDisplayText = ColoristeNomGetDisplayText
      end
    end
  end
end
