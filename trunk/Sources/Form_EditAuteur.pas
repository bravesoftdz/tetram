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
    FRefAuteur: Integer;
    FCreation: Boolean;
    procedure SetRefAuteur(const Value: Integer);
  public
    { Déclarations publiques }
    property RefAuteur: Integer read FRefAuteur write SetRefAuteur;
  end;

implementation

uses Commun, JvUIB, DM_Princ, LoadComplet, ShellAPI;

{$R *.DFM}

procedure TFrmEditAuteur.SetRefAuteur(const Value: Integer);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FRefAuteur := Value;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM PERSONNES WHERE REFPERSONNE = ?';
    Params.AsInteger[0] := FRefAuteur;
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
      SQL.Text := 'INSERT INTO PERSONNES (REFPERSONNE, NOMPERSONNE, SITEWEB, BIOGRAPHIE) VALUES (:REFPERSONNE, :NOMPERSONNE, :SITEWEB, :BIOGRAPHIE)'
    else
      SQL.Text := 'UPDATE PERSONNES SET NOMPERSONNE = :NOMPERSONNE, SITEWEB = :SITEWEB, BIOGRAPHIE = :BIOGRAPHIE WHERE REFPERSONNE = :REFPERSONNE';
    Params.ByNameAsString['NOMPERSONNE'] := Trim(edNom.Text);
    Params.ByNameAsString['SITEWEB'] := Trim(edSite.Text);
    s := edBiographie.Lines.Text;
    ParamsSetBlob('BIOGRAPHIE', s);

    Params.ByNameAsInteger['REFPERSONNE'] := RefAuteur;
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
