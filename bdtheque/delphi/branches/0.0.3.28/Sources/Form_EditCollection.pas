unit Form_EditCollection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, ComCtrls, VDTButton,
  Buttons, DBEditLabeled, VirtualTrees, VirtualTree;

type
  TFrmEditCollection = class(TForm)
    ScrollBox1: TScrollBox;
    Bevel2: TBevel;
    Label2: TLabel;
    edNom: TEditLabeled;
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnAnnuler: TBitBtn;
    Label5: TLabel;
    EditLabeled1: TEditLabeled;
    vtEditeurs: TVirtualStringTree;
    VDTButton1: TVDTButton;
    VDTButton9: TVDTButton;
    procedure FormCreate(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure Frame11btnAnnulerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure VDTButton1Click(Sender: TObject);
    procedure VDTButton9Click(Sender: TObject);
    procedure vtEditeursDblClick(Sender: TObject);
  private
    { Déclarations privées }
    FRefCollection: Integer;
    FCreation: Boolean;
    procedure SetRefCollection(Value: Integer);
  public
    { Déclarations publiques }
    FRefEditeur: Integer;
    property RefCollection: Integer read FRefCollection write SetRefCollection;
  end;

implementation

uses
  JvUIB, Commun, DM_Princ, Procedures, Proc_Gestions,
  Textes;

{$R *.DFM}

procedure TFrmEditCollection.FormCreate(Sender: TObject);
begin
  FRefEditeur := -1;
  PrepareLV(Self);
  vtEditeurs.Mode := vmEditeurs;
end;

procedure TFrmEditCollection.SetRefCollection(Value: Integer);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FRefCollection := Value;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMCOLLECTION, REFEDITEUR FROM COLLECTIONS WHERE RefCOLLECTION = ?';
    Params.AsInteger[0] := FRefCollection;
    Open;
    FCreation := Eof;
    if not FCreation then begin
      edNom.Text := Fields.ByNameAsString['NOMCOLLECTION'];
      FRefEditeur := Fields.ByNameAsInteger['REFEDITEUR'];
      vtEditeurs.Enabled := False;
      EditLabeled1.Enabled := False;
      VDTButton1.Enabled := False;
      VDTButton9.Enabled := False;
    end;
    vtEditeurs.CurrentValue := FRefEditeur;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TFrmEditCollection.Frame11btnOKClick(Sender: TObject);
var
  RefEditeur: Integer;
begin
  if Length(Trim(edNom.Text)) = 0 then begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  RefEditeur := vtEditeurs.CurrentValue;
  if RefEditeur = -1 then begin
    AffMessage(rsEditeurObligatoire, mtInformation, [mbOk], True);
    EditLabeled1.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    if FCreation then
      SQL.Text := 'INSERT INTO COLLECTIONS (REFCOLLECTION, NOMCOLLECTION, REFEDITEUR) VALUES (:REFCOLLECTION, :NOMCOLLECTION, :REFEDITEUR)'
    else
      SQL.Text := 'UPDATE COLLECTIONS SET NOMCOLLECTION = :NOMCOLLECTION, REFEDITEUR = :REFEDITEUR WHERE REFCOLLECTION = :REFCOLLECTION';
    Params.ByNameAsString['NOMCOLLECTION'] := Trim(edNom.Text);
    Params.ByNameAsInteger['REFEDITEUR'] := RefEditeur;
    Params.ByNameAsInteger['REFCOLLECTION'] := RefCollection;
    ExecSQL;
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditCollection.Frame11btnAnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditCollection.FormShow(Sender: TObject);
begin
  edNom.SetFocus;
end;

procedure TFrmEditCollection.VDTButton1Click(Sender: TObject);
begin
  vtEditeurs.Find(EditLabeled1.Text, Sender = VDTButton1);
end;

procedure TFrmEditCollection.VDTButton9Click(Sender: TObject);
begin
  AjouterEditeurs(vtEditeurs, EditLabeled1.Text);
end;

procedure TFrmEditCollection.vtEditeursDblClick(Sender: TObject);
begin
  ModifierEditeurs(vtEditeurs);
end;

end.
