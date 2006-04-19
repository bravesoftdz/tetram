unit Form_EditAuteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, Mask, Menus, ExtCtrls,
  DBEditLabeled, DB, Buttons, VDTButton;

type
  TFrmEditAuteur = class(TForm)
    ScrollBox1: TScrollBox;
    Bevel2: TBevel;
    edBiographie: TMemoLabeled;
    edNom: TEditLabeled;
    Label3: TLabel;
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnAnnuler: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    edSite: TEditLabeled;
    VDTButton13: TVDTButton;
    procedure Frame11btnOKClick(Sender: TObject);
    procedure btnAnnulerClick(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
  private
    { Déclarations privées }
    FID_Auteur: TGUID;
    FCreation: Boolean;
    procedure SetID_Auteur(const Value: TGUID);
  public
    { Déclarations publiques }
    property ID_Auteur: TGUID read FID_Auteur write SetID_Auteur;
  end;

implementation

uses Commun, JvUIB, DM_Princ, LoadComplet, ShellAPI;

{$R *.DFM}

procedure TFrmEditAuteur.SetID_Auteur(const Value: TGUID);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FID_Auteur := Value;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM PERSONNES WHERE ID_Personne = ?';
    Params.AsString[0] := GUIDToString(FID_Auteur);
    FetchBlobs := True;
    Open;
    FCreation := Eof;
    if not FCreation then begin
      edNom.Text := Fields.ByNameAsString['NOMPERSONNE'];
      edSite.Text := Fields.ByNameAsString['SITEWEB'];
      edBiographie.Lines.Text := Fields.ByNameAsString['BIOGRAPHIE'];
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TFrmEditAuteur.Frame11btnOKClick(Sender: TObject);
var
  s: string;
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    if FCreation then
      SQL.Text := 'INSERT INTO PERSONNES (ID_Personne, NOMPERSONNE, SITEWEB, BIOGRAPHIE) VALUES (:ID_Personne, :NOMPERSONNE, :SITEWEB, :BIOGRAPHIE)'
    else
      SQL.Text := 'UPDATE PERSONNES SET NOMPERSONNE = :NOMPERSONNE, SITEWEB = :SITEWEB, BIOGRAPHIE = :BIOGRAPHIE WHERE ID_Personne = :ID_Personne';
    Params.ByNameAsString['NOMPERSONNE'] := Trim(edNom.Text);
    Params.ByNameAsString['SITEWEB'] := Trim(edSite.Text);
    s := edBiographie.Lines.Text;
    ParamsSetBlob('BIOGRAPHIE', s);

    Params.ByNameAsString['ID_Personne'] := GUIDToString(ID_Auteur);
    ExecSQL;
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditAuteur.btnAnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditAuteur.edSiteChange(Sender: TObject);
begin
  VDTButton13.Enabled := Copy(LowerCase(edSite.Text), 1, 7) = 'http://';
end;

procedure TFrmEditAuteur.VDTButton13Click(Sender: TObject);
begin
  ShellExecute(Application.DialogHandle, nil, PChar(edSite.Text), nil, nil, SW_NORMAL);
end;

end.

