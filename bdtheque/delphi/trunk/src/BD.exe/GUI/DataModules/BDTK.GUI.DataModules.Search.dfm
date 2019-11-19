object dmSearch: TdmSearch
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Height = 351
  Width = 589
  object tblGenre: TUIBQuery
    SQL.Strings = (
      'SELECT ID_GENRE, GENRE FROM GENRES'
      'ORDER BY GENRE')
    Left = 96
    Top = 8
  end
  object tblCritereReliure: TUIBQuery
    SQL.Strings = (
      'SELECT REF, LIBELLE FROM LISTES'
      'WHERE CATEGORIE = 2'
      'ORDER BY ORDRE'
      '')
    Left = 96
    Top = 56
  end
  object tblCritereString: TUIBQuery
    SQL.Strings = (
      
        'SELECT REFCRITERE, CRITERE FROM CRITERES WHERE TYPE_CRITERE = '#39'S' +
        'TRING'#39)
    Left = 192
    Top = 8
  end
  object tblCritereBoolean: TUIBQuery
    SQL.Strings = (
      
        'SELECT REFCRITERE, CRITERE FROM CRITERES WHERE TYPE_CRITERE = '#39'B' +
        'OOL'#39)
    Left = 192
    Top = 56
  end
  object tblCritereNumeral: TUIBQuery
    SQL.Strings = (
      
        'SELECT REFCRITERE, CRITERE FROM CRITERES WHERE TYPE_CRITERE = '#39'N' +
        'UMERIC'#39)
    Left = 192
    Top = 104
  end
  object tblCritereTitre: TUIBQuery
    SQL.Strings = (
      
        'SELECT REFCRITERE, CRITERE FROM CRITERES WHERE TYPE_CRITERE = '#39'T' +
        'ITRE'#39)
    Left = 192
    Top = 152
  end
  object tblCritereAffiche: TUIBQuery
    SQL.Strings = (
      
        'SELECT REFCRITERE, CRITERE FROM CRITERES WHERE TYPE_CRITERE = '#39'I' +
        'MAGE'#39)
    Left = 192
    Top = 200
  end
  object tblCritereListe: TUIBQuery
    SQL.Strings = (
      
        'SELECT REFCRITERE, CRITERE FROM CRITERES WHERE TYPE_CRITERE = '#39'L' +
        'ISTE'#39)
    Left = 192
    Top = 248
  end
  object tblCritereEtat: TUIBQuery
    SQL.Strings = (
      'SELECT REF, LIBELLE FROM LISTES'
      'WHERE CATEGORIE = 1'
      'ORDER BY ORDRE')
    Left = 96
    Top = 104
  end
  object tblCritereLangueTitre: TUIBQuery
    SQL.Strings = (
      
        'SELECT REFCRITERE, CRITERE FROM CRITERES WHERE TYPE_CRITERE = '#39'L' +
        'ANGUETITRE'#39)
    Left = 280
    Top = 152
  end
  object tblCritereSensLecture: TUIBQuery
    SQL.Strings = (
      'SELECT REF, LIBELLE FROM LISTES'
      'WHERE CATEGORIE = 8'
      'ORDER BY ORDRE'
      '')
    Left = 96
    Top = 152
  end
  object tblCritereNotation: TUIBQuery
    SQL.Strings = (
      'SELECT REF, LIBELLE FROM LISTES'
      'WHERE CATEGORIE = 9'
      'ORDER BY ORDRE'
      '')
    Left = 96
    Top = 208
  end
end
