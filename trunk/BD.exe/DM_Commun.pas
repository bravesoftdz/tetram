unit DM_Commun;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, JvUIB;

type
  TDataCommun = class(TDataModule)
    TblGenres: TJvUIBQuery;
    TGenre: TJvUIBQuery;
    TCritereReliure: TJvUIBQuery;
    TCritereString: TJvUIBQuery;
    TCritereBoolean: TJvUIBQuery;
    TCritereNumeral: TJvUIBQuery;
    TCritereTitre: TJvUIBQuery;
    TCritereAffiche: TJvUIBQuery;
    TCritereListe: TJvUIBQuery;
    TCritereEtat: TJvUIBQuery;
    TCritereLangueTitre: TJvUIBQuery;
    TCritereSensLecture: TJvUIBQuery;
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  DataCommun: TDataCommun;

implementation

{$R *.DFM}

procedure TDataCommun.DataModuleDestroy(Sender: TObject);
begin
  DataCommun := nil;
end;

end.
