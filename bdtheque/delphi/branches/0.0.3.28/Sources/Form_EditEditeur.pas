unit Form_EditEditeur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, ComCtrls, VDTButton,
  Buttons, DBEditLabeled, ShellAPI;

type
  TFrmEditEditeur = class(TForm)
    ScrollBox1: TScrollBox;
    Bevel2: TBevel;
    Label2: TLabel;
    edNom: TEditLabeled;
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnAnnuler: TBitBtn;
    Label1: TLabel;
    edSite: TEditLabeled;
    VDTButton13: TVDTButton;
    procedure FormCreate(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure Frame11btnAnnulerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
  private
    { Déclarations privées }
    FRefEditeur: Integer;
    FCreation: Boolean;
    procedure SetRefEditeur(Value: Integer);
  public
    { Déclarations publiques }
    property RefEditeur: Integer read FRefEditeur write SetRefEditeur;
  end;

implementation

uses
  JvUIB, Commun, DM_Princ, Procedures, Textes;

{$R *.DFM}

procedure TFrmEditEditeur.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
end;

procedure TFrmEditEditeur.SetRefEditeur(Value: Integer);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FRefEditeur := Value;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMEDITEUR, SITEWEB FROM EDITEURS WHERE RefEditeur = ?';
    Params.AsInteger[0] := FRefEditeur;
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
      SQL.Text := 'INSERT INTO EDITEURS (REFEDITEUR, NOMEDITEUR, SITEWEB) VALUES (:REFEDITEUR, :NOMEDITEUR, :SITEWEB)'
    else
      SQL.Text := 'UPDATE EDITEURS SET NOMEDITEUR = :NOMEDITEUR, SITEWEB = :SITEWEB WHERE REFEDITEUR = :REFEDITEUR';
    Params.ByNameAsString['NOMEDITEUR'] := Trim(edNom.Text);
    Params.ByNameAsString['SITEWEB'] := Trim(edSite.Text);
    Params.ByNameAsInteger['REFEDITEUR'] := RefEditeur;
    ExecSQL;
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditEditeur.Frame11btnAnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
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
