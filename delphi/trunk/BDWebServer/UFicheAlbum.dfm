object FicheAlbum: TFicheAlbum
  OldCreateOrder = False
  OnCreate = WebPageModuleCreate
  PageProducer = PageProducer
  OnBeforeDispatchPage = WebPageModuleBeforeDispatchPage
  OnAfterDispatchPage = WebPageModuleAfterDispatchPage
  Left = 790
  Top = 109
  Height = 243
  Width = 318
  object PageProducer: TPageProducer
    HTMLFile = 'WebServer\FicheAlbum.html'
    ScriptEngine = 'JScript'
    Left = 48
    Top = 8
  end
  object Album: TAdapter
    Left = 48
    Top = 56
    object TAdapterActions
    end
    object TAdapterFields
      object RefAlbum: TAdapterField
        OnGetValue = RefALbumGetValue
        ReadOnly = True
      end
      object AnneeParution: TAdapterField
        OnGetValue = AnneeParutionGetValue
        OnGetDisplayText = AnneeParutionGetDisplayText
        ReadOnly = True
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
      end
      object HistoireAlbum: TAdapterMemoField
        OnGetValue = HistoireAlbumGetValue
        FieldName = 'Histoire'
        ReadOnly = True
      end
      object NotesAlbum: TAdapterMemoField
        OnGetValue = NotesAlbumGetValue
        FieldName = 'Notes'
        ReadOnly = True
      end
    end
  end
  object Scenaristes: TPagedAdapter
    OnGetRecordIndex = ScenaristesGetRecordIndex
    OnGetRecordCount = ScenaristesGetRecordCount
    OnGetFirstRecord = ScenaristesGetFirstRecord
    OnGetNextRecord = ScenaristesGetNextRecord
    Left = 128
    Top = 56
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object ScenaristeRefPersonne: TAdapterField
        FieldName = 'RefPersonne'
        OnGetValue = ScenaristeRefPersonneGetValue
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
    Left = 192
    Top = 56
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object DessinateurRefPersonne: TAdapterField
        FieldName = 'RefPersonne'
        OnGetValue = DessinateurRefPersonneGetValue
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
  object Genres: TPagedAdapter
    OnGetRecordIndex = GenresGetRecordIndex
    OnGetRecordCount = GenresGetRecordCount
    OnGetFirstRecord = GenresGetFirstRecord
    OnGetNextRecord = GenresGetNextRecord
    Left = 128
    Top = 104
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
  object Coloristes: TPagedAdapter
    OnGetRecordIndex = ColoristesGetRecordIndex
    OnGetRecordCount = ColoristesGetRecordCount
    OnGetFirstRecord = ColoristesGetFirstRecord
    OnGetNextRecord = ColoristesGetNextRecord
    Left = 256
    Top = 56
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object ColoristeRefPersonne: TAdapterField
        FieldName = 'RefPersonne'
        OnGetValue = ColoristeRefPersonneGetValue
      end
      object ColoristeNom: TAdapterField
        FieldName = 'Nom'
        OnGetValue = ColoristeNomGetValue
        OnGetDisplayText = ColoristeNomGetDisplayText
      end
    end
  end
  object Serie: TAdapter
    Left = 48
    Top = 104
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
      end
      object HistoireSerie: TAdapterMemoField
        OnGetValue = HistoireSerieGetValue
        FieldName = 'Histoire'
      end
      object NotesSerie: TAdapterMemoField
        OnGetValue = NotesSerieGetValue
        FieldName = 'Notes'
      end
    end
  end
  object Editions: TPagedAdapter
    OnGetRecordIndex = EditionsGetRecordIndex
    OnGetRecordCount = EditionsGetRecordCount
    OnGetFirstRecord = EditionsGetFirstRecord
    OnGetNextRecord = EditionsGetNextRecord
    Left = 48
    Top = 152
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object RefEdition: TAdapterField
        OnGetValue = RefEditionGetValue
        ReadOnly = True
      end
      object Edition: TAdapterField
        OnGetValue = EditionGetValue
        OnGetDisplayText = EditionGetDisplayText
      end
      object AnneeEdition: TAdapterField
        OnGetValue = AnneeEditionGetValue
        OnGetDisplayText = AnneeEditionGetDisplayText
      end
      object Etat: TAdapterField
        OnGetValue = EtatGetValue
        OnGetDisplayText = EtatGetDisplayText
      end
      object Reliure: TAdapterField
        OnGetValue = ReliureGetValue
        OnGetDisplayText = ReliureGetDisplayText
      end
      object Prix: TAdapterField
        OnGetValue = PrixGetValue
        OnGetDisplayText = PrixGetDisplayText
      end
      object Couleur: TAdapterBooleanField
        OnGetValue = CouleurGetValue
      end
      object VO: TAdapterBooleanField
        OnGetValue = VOGetValue
      end
      object Dedicace: TAdapterBooleanField
        OnGetValue = DedicaceGetValue
      end
      object Gratuit: TAdapterBooleanField
        OnGetValue = GratuitGetValue
      end
      object Offert: TAdapterBooleanField
        OnGetValue = OffertGetValue
      end
      object Stock: TAdapterBooleanField
        OnGetValue = StockGetValue
      end
      object Prete: TAdapterBooleanField
        OnGetValue = PreteGetValue
      end
      object ISBN: TAdapterField
        OnGetValue = ISBNGetValue
      end
      object DateAchat: TAdapterField
        OnGetValue = DateAchatGetValue
        OnGetDisplayText = DateAchatGetDisplayText
      end
      object EditionNotes: TAdapterMemoField
        OnGetValue = EditionNotesGetValue
        FieldName = 'Notes'
      end
      object RefEditeur: TAdapterField
        OnGetValue = RefEditeurGetValue
      end
      object NomEditeur: TAdapterField
        OnGetValue = NomEditeurGetValue
        OnGetDisplayText = NomEditeurGetDisplayText
      end
      object EditeurSiteWeb: TAdapterField
        OnGetValue = EditeurSiteWebGetValue
        OnGetDisplayText = EditeurSiteWebGetDisplayText
      end
      object RefCollection: TAdapterField
        OnGetValue = RefCollectionGetValue
      end
      object NomCollection: TAdapterField
        OnGetValue = NomCollectionGetValue
      end
      object NombreDePages: TAdapterField
        OnGetValue = NombreDePagesGetValue
        OnGetDisplayText = NombreDePagesGetDisplayText
      end
      object Orientation: TAdapterField
        OnGetValue = OrientationGetValue
        OnGetDisplayText = OrientationGetDisplayText
      end
      object FormatEdition: TAdapterField
        OnGetValue = FormatEditionGetValue
        OnGetDisplayText = FormatEditionGetDisplayText
      end
    end
  end
  object Couvertures: TPagedAdapter
    OnGetRecordIndex = CouverturesGetRecordIndex
    OnGetRecordCount = CouverturesGetRecordCount
    OnGetFirstRecord = CouverturesGetFirstRecord
    OnGetNextRecord = CouverturesGetNextRecord
    Left = 128
    Top = 152
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object RefCouverture: TAdapterField
        OnGetValue = RefCouvertureGetValue
      end
      object Couverture: TAdapterImageField
        OnGetImageName = CouvertureGetImageName
        OnGetHREF = CouvertureGetHREF
      end
    end
  end
end
