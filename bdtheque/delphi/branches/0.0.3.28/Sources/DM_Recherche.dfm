object DataRecherche: TDataRecherche
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 431
  Top = 145
  Height = 540
  Width = 783
  object TGenre: TTable
    DatabaseName = 'VDT'
    TableName = 'Genres.DB'
    Left = 66
    Top = 8
    object TGenreRefGenre: TIntegerField
      FieldName = 'RefGenre'
    end
    object TGenreCritere: TStringField
      DisplayLabel = 'Genre'
      FieldKind = fkLookup
      FieldName = 'Critere'
      LookupDataSet = TblGenres
      LookupKeyFields = 'RefGenre'
      LookupResultField = 'Genre'
      KeyFields = 'RefGenre'
      Lookup = True
    end
  end
  object TCritereString: TMemoryTable
    AutoCalcFields = False
    DatabaseName = 'VDT'
    EnableDelete = False
    TableName = 'CritereString'
    Left = 138
    Top = 8
    object TCritereStringref: TIntegerField
      FieldName = 'RefCritere'
    end
    object TCritereStringGenre: TStringField
      DisplayWidth = 15
      FieldName = 'Critere'
    end
  end
  object TCritereBoolean: TMemoryTable
    AutoCalcFields = False
    DatabaseName = 'VDT'
    EnableDelete = False
    TableName = 'CritereBoolean'
    Left = 138
    Top = 56
    object TCritereBooleanref: TIntegerField
      FieldName = 'RefCritere'
    end
    object TCritereBooleanGenre: TStringField
      DisplayWidth = 15
      FieldName = 'Critere'
    end
  end
  object TCritereNumeral: TMemoryTable
    AutoCalcFields = False
    DatabaseName = 'VDT'
    EnableDelete = False
    TableName = 'CritereNumeral'
    Left = 138
    Top = 104
    object TCritereNumeralRef: TIntegerField
      FieldName = 'RefCritere'
    end
    object TCritereNumeralGenre: TStringField
      DisplayWidth = 15
      FieldName = 'Critere'
    end
  end
  object TCritereAffiche: TMemoryTable
    AutoCalcFields = False
    DatabaseName = 'VDT'
    EnableDelete = False
    TableName = 'CritereAffiche'
    Left = 138
    Top = 152
    object IntegerField1: TIntegerField
      FieldName = 'RefCritere'
    end
    object StringField1: TStringField
      DisplayWidth = 15
      FieldName = 'Critere'
    end
  end
  object TCriterePays: TTable
    DatabaseName = 'VDT'
    TableName = 'Pays.DB'
    Left = 64
    Top = 104
    object TCriterePaysRefPays: TIntegerField
      FieldName = 'RefPays'
    end
    object TCriterePaysCritere: TStringField
      FieldKind = fkLookup
      FieldName = 'Critere'
      LookupDataSet = TblPays
      LookupKeyFields = 'RefPays'
      LookupResultField = 'Pays'
      KeyFields = 'RefPays'
      Lookup = True
    end
  end
  object TCritereTypeSupport: TTable
    DatabaseName = 'VDT'
    TableName = 'TypesSupport.DB'
    Left = 64
    Top = 56
    object TCritereTypeSupportRefTypeSupport: TIntegerField
      FieldName = 'RefTypeSupport'
    end
    object TCritereTypeSupportType: TStringField
      FieldName = 'TypeSupport'
      Size = 10
    end
  end
  object TblGenres: TTable
    DatabaseName = 'VDT'
    TableName = 'Genres.DB'
    Left = 16
    Top = 176
  end
  object TblPays: TTable
    DatabaseName = 'VDT'
    TableName = 'Pays.DB'
    Left = 16
    Top = 224
  end
end
