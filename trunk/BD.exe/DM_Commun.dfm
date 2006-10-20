object DataCommun: TDataCommun
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 517
  Top = 380
  Height = 351
  Width = 589
  object TblGenres: TJvUIBQuery
    SQL.Strings = (
      'SELECT ID_GENRE, GENRE FROM GENRES ORDER BY UPPERGENRE')
    Left = 16
    Top = 8
  end
  object TGenre: TJvUIBQuery
    SQL.Strings = (
      'SELECT ID_GENRE, GENRE FROM GENRES'
      'ORDER BY GENRE')
    Left = 96
    Top = 8
  end
  object TCritereReliure: TJvUIBQuery
    SQL.Strings = (
      'SELECT REF, LIBELLE FROM LISTES'
      'WHERE CATEGORIE = 2'
      'ORDER BY ORDRE'
      '')
    Left = 96
    Top = 56
  end
  object TCritereString: TJvUIBQuery
    SQL.Strings = (
      'SELECT REFCRITERE, CRITERE FROM CRITERESTRING')
    Left = 192
    Top = 8
  end
  object TCritereBoolean: TJvUIBQuery
    SQL.Strings = (
      'SELECT REFCRITERE, CRITERE FROM CRITEREBOOLEAN')
    Left = 192
    Top = 56
  end
  object TCritereNumeral: TJvUIBQuery
    SQL.Strings = (
      'SELECT REFCRITERE, CRITERE FROM CRITERENUMERAL')
    Left = 192
    Top = 104
  end
  object TCritereTitre: TJvUIBQuery
    SQL.Strings = (
      'SELECT REFCRITERE, CRITERE FROM CRITERETITRE')
    Left = 192
    Top = 152
  end
  object TCritereAffiche: TJvUIBQuery
    SQL.Strings = (
      'SELECT REFCRITERE, CRITERE FROM CRITEREAFFICHE')
    Left = 192
    Top = 200
  end
  object TCritereListe: TJvUIBQuery
    SQL.Strings = (
      'SELECT REFCRITERE, CRITERE FROM CRITERELISTE')
    Left = 192
    Top = 248
  end
  object TCritereEtat: TJvUIBQuery
    SQL.Strings = (
      'SELECT REF, LIBELLE FROM LISTES'
      'WHERE CATEGORIE = 1'
      'ORDER BY ORDRE')
    Left = 96
    Top = 104
  end
  object TCritereLangueTitre: TJvUIBQuery
    SQL.Strings = (
      'SELECT REFCRITERE, CRITERE FROM CRITERELANGUETITRE')
    Left = 280
    Top = 152
  end
end
