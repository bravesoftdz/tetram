object Previsions: TPrevisions
  OldCreateOrder = False
  OnCreate = WebPageModuleCreate
  PageProducer = PageProducer
  OnBeforeDispatchPage = WebPageModuleBeforeDispatchPage
  OnAfterDispatchPage = WebPageModuleAfterDispatchPage
  Left = 841
  Top = 93
  Height = 150
  Width = 367
  object PageProducer: TPageProducer
    HTMLFile = 'WebServer\repertoire.html'
    ScriptEngine = 'JScript'
    Left = 48
    Top = 8
  end
  object AnneesPassees: TPagedAdapter
    OnGetRecordIndex = AnneesPasseesGetRecordIndex
    OnGetRecordCount = AnneesPasseesGetRecordCount
    OnGetFirstRecord = AnneesPasseesGetFirstRecord
    OnGetNextRecord = AnneesPasseesGetNextRecord
    Left = 48
    Top = 72
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object APRefSerie: TAdapterField
        FieldName = 'RefSerie'
        OnGetValue = APRefSerieGetValue
      end
      object APTome: TAdapterField
        FieldName = 'Tome'
        OnGetValue = APTomeGetValue
        OnGetDisplayText = APTomeGetDisplayText
      end
      object APAnnee: TAdapterField
        FieldName = 'Annee'
        OnGetValue = APAnneeGetValue
        OnGetDisplayText = APAnneeGetDisplayText
      end
      object APTitreSerie: TAdapterField
        FieldName = 'TitreSerie'
        OnGetValue = APTitreSerieGetValue
        OnGetDisplayText = APTitreSerieGetDisplayText
      end
      object APLibelle: TAdapterField
        FieldName = 'Libelle'
        OnGetDisplayText = APLibelleGetDisplayText
      end
      object APLibelleCourt: TAdapterField
        FieldName = 'LibelleCourt'
        OnGetDisplayText = APLibelleCourtGetDisplayText
      end
    end
  end
  object AnneeEnCours: TPagedAdapter
    OnGetRecordIndex = AnneeEnCoursGetRecordIndex
    OnGetRecordCount = AnneeEnCoursGetRecordCount
    OnGetFirstRecord = AnneeEnCoursGetFirstRecord
    OnGetNextRecord = AnneeEnCoursGetNextRecord
    Left = 136
    Top = 72
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object ACRefSerie: TAdapterField
        FieldName = 'RefSerie'
        OnGetValue = ACRefSerieGetValue
      end
      object ACTome: TAdapterField
        FieldName = 'Tome'
        OnGetValue = ACTomeGetValue
        OnGetDisplayText = ACTomeGetDisplayText
      end
      object ACAnnee: TAdapterField
        FieldName = 'Annee'
        OnGetValue = ACAnneeGetValue
        OnGetDisplayText = ACAnneeGetDisplayText
      end
      object ACTitreSerie: TAdapterField
        FieldName = 'TitreSerie'
        OnGetValue = ACTitreSerieGetValue
        OnGetDisplayText = ACTitreSerieGetDisplayText
      end
      object ACLibelle: TAdapterField
        FieldName = 'Libelle'
        OnGetDisplayText = ACLibelleGetDisplayText
      end
      object ACLibelleCourt: TAdapterField
        FieldName = 'LibelleCourt'
        OnGetDisplayText = ACLibelleCourtGetDisplayText
      end
    end
  end
  object AnneesProchaines: TPagedAdapter
    OnGetRecordIndex = AnneesProchainesGetRecordIndex
    OnGetRecordCount = AnneesProchainesGetRecordCount
    OnGetFirstRecord = AnneesProchainesGetFirstRecord
    OnGetNextRecord = AnneesProchainesGetNextRecord
    Left = 232
    Top = 72
    object TAdapterDefaultActions
    end
    object TAdapterDefaultFields
      object prRefSerie: TAdapterField
        FieldName = 'RefSerie'
        OnGetValue = prRefSerieGetValue
      end
      object prTome: TAdapterField
        FieldName = 'Tome'
        OnGetValue = prTomeGetValue
        OnGetDisplayText = prTomeGetDisplayText
      end
      object prAnnee: TAdapterField
        FieldName = 'Annee'
        OnGetValue = prAnneeGetValue
        OnGetDisplayText = prAnneeGetDisplayText
      end
      object prTitreSerie: TAdapterField
        FieldName = 'TitreSerie'
        OnGetValue = prTitreSerieGetValue
        OnGetDisplayText = prTitreSerieGetDisplayText
      end
      object prLibelle: TAdapterField
        FieldName = 'Libelle'
        OnGetDisplayText = prLibelleGetDisplayText
      end
      object prLibelleCourt: TAdapterField
        FieldName = 'LibelleCourt'
        OnGetDisplayText = prLibelleCourtGetDisplayText
      end
    end
  end
end
