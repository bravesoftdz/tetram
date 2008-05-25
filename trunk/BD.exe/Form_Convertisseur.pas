unit Form_Convertisseur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Fram_Boutons, UBdtForms;

type
  TFrmConvers = class(TbdtForm)
    Panel1: TPanel;
    Frame11: TFrame1;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    FValeur: Currency;
    ListFC: TList;
    FFirstEdit: TEdit;
    procedure SetValue(Value: Currency);
  public
    { Déclarations publiques }
    property Valeur: Currency read FValeur write SetValue;
  end;

var
  FrmConvers: TFrmConvers;

implementation

uses Frame_Convertisseur, CommonConst, TypeRec, DM_Princ, JvUIB, Commun;

{$R *.DFM}

procedure TFrmConvers.FormCreate(Sender: TObject);
var
  q: TJvUIBQuery;
  fc: TConvertisseur;
  PC: TConversion;
  i: Integer;
begin
  FFirstEdit := nil;
  ListFC := TList.Create;
  PC := TConversion.Create;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT Monnaie1, Monnaie2, Taux FROM conversions WHERE Monnaie1 = ? OR Monnaie2 = ?';
    Params.AsString[0] := Utilisateur.Options.SymboleMonnetaire;
    Params.AsString[1] := Utilisateur.Options.SymboleMonnetaire;
    Open;
    i := 0;
    while not EOF do begin
      PC.Fill(Q);
      fc := TConvertisseur.Create(Self);
      if PC.Monnaie1 = Utilisateur.Options.SymboleMonnetaire then begin
        fc.Label1.Caption := PC.Monnaie2;
        fc.FTaux := 1 / PC.Taux;
      end
      else begin
        fc.Label1.Caption := PC.Monnaie1;
        fc.FTaux := PC.Taux;
      end;
      fc.Edit1.Text := '';
      fc.Visible := True;
      fc.Parent := Panel1;
      fc.Name := fc.name + IntToStr(i);
      ListFC.Add(fc);
      Inc(i, fc.Height);
      if not Assigned(FFirstEdit) then FFirstEdit := fc.Edit1;
      Next;
    end;
    ClientHeight := frame11.Height + i + 4;
  finally
    Transaction.Free;
    Free;
    PC.Free;
  end;
end;

procedure TFrmConvers.FormDestroy(Sender: TObject);
begin
  ListFC.Free;
end;

procedure TFrmConvers.SetValue(Value: Currency);
var
  i: Integer;
  fc: TConvertisseur;
begin
  for i := 0 to ListFC.Count - 1 do begin
    fc := TConvertisseur(ListFC[i]);
    fc.Edit1.Text := '';
    try
      fc.Edit1.Text := FormatCurr(FormatMonnaieSimple, Value / fc.FTaux);
    except
    end;
  end;
  FValeur := Value;
end;

procedure TFrmConvers.FormShow(Sender: TObject);
begin
  if Assigned(FFirstEdit) then FFirstEdit.SetFocus;
end;

end.
