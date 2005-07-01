unit DM_Recherche;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MemoryTable, Db, DBTables;

type
  TDataRecherche = class(TDataModule)
    TGenre: TTable;
    TGenreRefGenre: TIntegerField;
    TGenreCritere: TStringField;
    TCritereString: TMemoryTable;
    TCritereStringref: TIntegerField;
    TCritereStringGenre: TStringField;
    TCritereBoolean: TMemoryTable;
    TCritereBooleanref: TIntegerField;
    TCritereBooleanGenre: TStringField;
    TCritereNumeral: TMemoryTable;
    TCritereNumeralRef: TIntegerField;
    TCritereNumeralGenre: TStringField;
    TCritereAffiche: TMemoryTable;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    TCriterePays: TTable;
    TCriterePaysRefPays: TIntegerField;
    TCriterePaysCritere: TStringField;
    TCritereTypeSupport: TTable;
    TCritereTypeSupportRefTypeSupport: TIntegerField;
    TCritereTypeSupportType: TStringField;
    TblGenres: TTable;
    TblPays: TTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  DataRecherche: TDataRecherche;

implementation

uses Commun, Textes;

{$R *.DFM}

procedure TDataRecherche.DataModuleCreate(Sender: TObject);
begin
  SetDatabaseName(Self);
  TCritereString.Open;
  TCritereString.AppendRecord([1, TransVideOuContient]);
  TCritereString.AppendRecord([2, TransContient]);
  TCritereString.AppendRecord([3, TransNeContientPas]);
  TCritereBoolean.Open;
  TCritereBoolean.AppendRecord([1, TransOui]);
  TCritereBoolean.AppendRecord([2, TransNon]);
  TCritereNumeral.Open;
  TCritereNumeral.AppendRecord([1, '=']);
  TCritereNumeral.AppendRecord([2, '>']);
  TCritereNumeral.AppendRecord([3, '<']);
  TCritereNumeral.AppendRecord([4, '>=']);
  TCritereNumeral.AppendRecord([5, '<=']);
  TCritereNumeral.AppendRecord([6, '<>']);
  TCritereAffiche.Open;
  TCritereAffiche.AppendRecord([1, TransOui]);
  TCritereAffiche.AppendRecord([2, TransNon]);
  TCritereAffiche.AppendRecord([3, TransValide]);
  TCritereAffiche.AppendRecord([4, TransInValide]);
end;

end.
