unit UdmCommun;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, uib;

type
  TdmCommun = class(TDataModule)
    tblGenre: TUIBQuery;
    tblCritereReliure: TUIBQuery;
    tblCritereString: TUIBQuery;
    tblCritereBoolean: TUIBQuery;
    tblCritereNumeral: TUIBQuery;
    tblCritereTitre: TUIBQuery;
    tblCritereAffiche: TUIBQuery;
    tblCritereListe: TUIBQuery;
    tblCritereEtat: TUIBQuery;
    tblCritereLangueTitre: TUIBQuery;
    tblCritereSensLecture: TUIBQuery;
    tblCritereNotation: TUIBQuery;
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
  end;

var
  dmCommun: TdmCommun;

implementation

uses
  BDTK.Main.DataModule, Commun, Divers;

{$R *.DFM}

procedure TdmCommun.DataModuleDestroy(Sender: TObject);
begin
  dmCommun := nil;
end;

end.
