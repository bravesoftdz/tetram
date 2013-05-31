unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvUIB, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    function GetID_Album: TGUID;
    procedure SetID_Album(const Value: TGUID);
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

uses Commun, DM_Princ, LoadComplet;

{$R *.dfm}

function TForm1.GetID_Album: TGUID;
begin
  Result := GUID_NULL;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDatabase);
    SQL.Text := 'SELECT FIRST 1 ID_ALBUM FROM ALBUMS';
    Open;
    Result := Fields.AsGUID[0];
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Album: TAlbumComplet;
begin
  Album := TAlbumComplet.Create(GetID_Album);
  try
    if Album.RecInconnu then
      ShowMessage('RecInconnu')
    else
      ShowMessage(Album.ChaineAffichage);
    SetID_Album(Album.ID_Album);
  finally
    Album.Free;
  end;
end;

procedure TForm1.SetID_Album(const Value: TGUID);
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDatabase);
    SQL.Text := 'UPDATE ALBUMS SET TitreALbum = :Value WHERE ID_ALBUM = :Value';
    Params.AsGUID[0] := Value;
    ExecSQL;
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
end;

end.
