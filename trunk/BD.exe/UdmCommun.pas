unit UdmCommun;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, uib;

type
  TdmCommun = class(TDataModule)
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
  dmCommun: TdmCommun;

implementation

{$R *.DFM}

procedure TdmCommun.DataModuleDestroy(Sender: TObject);
begin
  dmCommun := nil;
end;

end.
