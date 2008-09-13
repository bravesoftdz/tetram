unit DM_Commun;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, uib;

type
  TDataCommun = class(TDataModule)
    TblGenres: TUIBQuery;
    TGenre: TUIBQuery;
    TCritereReliure: TUIBQuery;
    TCritereString: TUIBQuery;
    TCritereBoolean: TUIBQuery;
    TCritereNumeral: TUIBQuery;
    TCritereTitre: TUIBQuery;
    TCritereAffiche: TUIBQuery;
    TCritereListe: TUIBQuery;
    TCritereEtat: TUIBQuery;
    TCritereLangueTitre: TUIBQuery;
    TCritereSensLecture: TUIBQuery;
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
