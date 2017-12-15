unit BDTK.GUI.DataModules.Search;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, uib;

type
  TdmSearch = class(TDataModule)
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
  dmSearch: TdmSearch;

implementation

uses
  BDTK.GUI.DataModules.Main, BD.Utils.StrUtils, Divers;

{$R *.DFM}

procedure TdmSearch.DataModuleDestroy(Sender: TObject);
begin
  dmSearch := nil;
end;

end.
