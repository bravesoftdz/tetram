unit Form_EditEmprunteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, Mask, Menus, ExtCtrls,
  DBEditLabeled, DB, Buttons;

type
  TFrmEditEmprunteur = class(TForm)
    ScrollBox1: TScrollBox;
    emprunts: TLabel;
    Label2: TLabel;
    Bevel2: TBevel;
    coord: TMemo;
    edNom: TEditLabeled;
    Label3: TLabel;
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnAnnuler: TBitBtn;
    procedure Frame11btnOKClick(Sender: TObject);
    procedure btnAnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
    FRefEmprunteur: Integer;
    FCreation: Boolean;
    procedure SetRefEmprunteur(const Value: Integer);
  public
    { Déclarations publiques }
    property RefEmprunteur: Integer read FRefEmprunteur write SetRefEmprunteur;
  end;

implementation

uses Commun, JvUIB, DM_Princ, LoadComplet;

const
  PasModifier = 'Impossible de modifier la fiche !';
  PasAjouter = 'Impossible d''ajouter la fiche !';

{$R *.DFM}

procedure TFrmEditEmprunteur.SetRefEmprunteur(const Value: Integer);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FRefEmprunteur := Value;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM EMPRUNTEURS WHERE REFEMPRUNTEUR = ?';
    Params.AsInteger[0] := FRefEmprunteur;
    FetchBlobs := True;
    Open;
    FCreation := Eof;
    if not FCreation then begin
      edNom.Text := Fields.ByNameAsString['NOMEMPRUNTEUR'];
      Coord.Lines.Text := Fields.ByNameAsString['ADRESSEEMPRUNTEUR'];
      with TEmpruntsComplet.Create(FRefEmprunteur, seEmprunteur, ssPret) do try
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
      SQL.Text := 'INSERT INTO EMPRUNTEURS (REFEMPRUNTEUR, NOMEMPRUNTEUR, ADRESSEEMPRUNTEUR) VALUES (:REFEMPRUNTEUR, :NOMEMPRUNTEUR, :ADRESSEEMPRUNTEUR)'
    else
      SQL.Text := 'UPDATE EMPRUNTEURS SET NOMEMPRUNTEUR = :NOMEMPRUNTEUR, ADRESSEEMPRUNTEUR = :ADRESSEEMPRUNTEUR WHERE REFEMPRUNTEUR = :REFEMPRUNTEUR';
    Params.ByNameAsString['NOMEMPRUNTEUR'] := Trim(edNom.Text);
    s := Coord.Lines.Text;
    ParamsSetBlob('ADRESSEEMPRUNTEUR', s);

    Params.ByNameAsInteger['RefEmprunteur'] := RefEmprunteur;
    ExecSQL;
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditEmprunteur.btnAnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
