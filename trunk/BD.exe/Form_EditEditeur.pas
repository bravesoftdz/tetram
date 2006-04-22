unit Form_EditEditeur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, ComCtrls, VDTButton,
  Buttons, DBEditLabeled, ShellAPI, Fram_Boutons;

type
  TFrmEditEditeur = class(TForm)
    ScrollBox1: TScrollBox;
    Label2: TLabel;
    edNom: TEditLabeled;
    Label1: TLabel;
    edSite: TEditLabeled;
    VDTButton13: TVDTButton;
    Bevel1: TBevel;
    Frame11: TFrame1;
    procedure FormCreate(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
  private
    { Déclarations privées }
    FID_Editeur: TGUID;
    FCreation: Boolean;
    procedure SetID_Editeur(Value: TGUID);
  public
    { Déclarations publiques }
    property ID_Editeur: TGUID read FID_Editeur write SetID_Editeur;
  end;

implementation

uses
  JvUIB, Commun, DM_Princ, Procedures, Textes;

{$R *.DFM}

procedure TFrmEditEditeur.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
end;

procedure TFrmEditEditeur.SetID_Editeur(Value: TGUID);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FID_Editeur := Value;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMEDITEUR, SITEWEB FROM EDITEURS WHERE ID_Editeur = ?';
    Params.AsString[0] := GUIDToString(FID_Editeur);
    Open;
    FCreation := Eof;
    if not FCreation then begin
      edNom.Text := Fields.ByNameAsString['NOMEDITEUR'];
      edSite.Text := Fields.ByNameAsString['SITEWEB'];
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TFrmEditEditeur.Frame11btnOKClick(Sender: TObject);
begin
  if Length(Trim(edNom.Text)) = 0 then begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    if FCreation then
      SQL.Text := 'INSERT INTO EDITEURS (ID_Editeur, NOMEDITEUR, SITEWEB) VALUES (:ID_Editeur, :NOMEDITEUR, :SITEWEB)'
    else
      SQL.Text := 'UPDATE EDITEURS SET NOMEDITEUR = :NOMEDITEUR, SITEWEB = :SITEWEB WHERE ID_Editeur = :ID_Editeur';
    Params.ByNameAsString['NOMEDITEUR'] := Trim(edNom.Text);
    Params.ByNameAsString['SITEWEB'] := Trim(edSite.Text);
    Params.ByNameAsString['ID_Editeur'] := GUIDToString(ID_Editeur);
    ExecSQL;
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditEditeur.FormShow(Sender: TObject);
begin
  edNom.SetFocus;
end;

procedure TFrmEditEditeur.VDTButton13Click(Sender: TObject);
begin
  ShellExecute(Application.DialogHandle, nil, PChar(edSite.Text), nil, nil, SW_NORMAL);
end;

procedure TFrmEditEditeur.edSiteChange(Sender: TObject);
begin
  VDTButton13.Enabled := Copy(LowerCase(edSite.Text), 1, 7) = 'http://';
end;

end.
