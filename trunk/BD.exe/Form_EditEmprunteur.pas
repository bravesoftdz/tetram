unit Form_EditEmprunteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, Mask, Menus, ExtCtrls,
  DBEditLabeled, DB, Buttons, Fram_Boutons;

type
  TFrmEditEmprunteur = class(TForm)
    ScrollBox1: TScrollBox;
    emprunts: TLabel;
    Label2: TLabel;
    coord: TMemo;
    edNom: TEditLabeled;
    Label3: TLabel;
    Bevel1: TBevel;
    Frame11: TFrame1;
    procedure Frame11btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
    FID_Emprunteur: TGUID;
    FCreation: Boolean;
    procedure SetID_Emprunteur(const Value: TGUID);
  public
    { Déclarations publiques }
    property ID_Emprunteur: TGUID read FID_Emprunteur write SetID_Emprunteur;
  end;

implementation

uses Commun, JvUIB, DM_Princ, LoadComplet;

const
  PasModifier = 'Impossible de modifier la fiche !';
  PasAjouter = 'Impossible d''ajouter la fiche !';

{$R *.DFM}

procedure TFrmEditEmprunteur.SetID_Emprunteur(const Value: TGUID);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FID_Emprunteur := Value;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM EMPRUNTEURS WHERE ID_Emprunteur = ?';
    Params.AsString[0] := GUIDToString(FID_Emprunteur);
    FetchBlobs := True;
    Open;
    FCreation := Eof;
    if not FCreation then begin
      edNom.Text := Fields.ByNameAsString['NOMEMPRUNTEUR'];
      Coord.Lines.Text := Fields.ByNameAsString['ADRESSEEMPRUNTEUR'];
      with TEmpruntsComplet.Create(FID_Emprunteur, seEmprunteur, ssPret) do try
        Self.emprunts.Caption := IntToStr(NBEmprunts);
      finally
        Free;
      end;
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TFrmEditEmprunteur.Frame11btnOKClick(Sender: TObject);
var
  s: string;
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    if FCreation then
      SQL.Text := 'INSERT INTO EMPRUNTEURS (ID_Emprunteur, NOMEMPRUNTEUR, ADRESSEEMPRUNTEUR) VALUES (:ID_Emprunteur, :NOMEMPRUNTEUR, :ADRESSEEMPRUNTEUR)'
    else
      SQL.Text := 'UPDATE EMPRUNTEURS SET NOMEMPRUNTEUR = :NOMEMPRUNTEUR, ADRESSEEMPRUNTEUR = :ADRESSEEMPRUNTEUR WHERE ID_Emprunteur = :ID_Emprunteur';
    Params.ByNameAsString['NOMEMPRUNTEUR'] := Trim(edNom.Text);
    s := Coord.Lines.Text;
    ParamsSetBlob('ADRESSEEMPRUNTEUR', s);

    Params.ByNameAsString['ID_Emprunteur'] := GUIDToString(ID_Emprunteur);
    ExecSQL;
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

end.
