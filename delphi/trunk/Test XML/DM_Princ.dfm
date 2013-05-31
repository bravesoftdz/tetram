object DMPrinc: TDMPrinc
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 466
  Top = 125
  Height = 150
  Width = 215
  object UIBDatabase: TJvUIBDataBase
    Params.Strings = (
      'sql_dialect=3'
      'lc_ctype=NONE')
    LibraryName = 'gds32.dll'
    Left = 40
    Top = 8
  end
end
