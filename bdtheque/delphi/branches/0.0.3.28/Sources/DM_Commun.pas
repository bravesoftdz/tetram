unit DM_Commun;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, JvUIB;

type
  TDataCommun = class(TDataModule)
    TblGenres: TJvUIBQuery;
    TblPays: TJvUIBQuery;
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
    procedure DataModuleDestroy(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
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
