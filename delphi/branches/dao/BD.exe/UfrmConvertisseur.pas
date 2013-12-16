unit UfrmConvertisseur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, UframBoutons, UBdtForms, Generics.Collections,
  UframConvertisseur;

type
  TFrmConvers = class(TbdtForm)
    Panel1: TPanel;
    Frame11: TframBoutons;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    FValeur: Currency;
    ListFC: TList<TframConvertisseur>;
    FFirstEdit: TEdit;
    procedure SetValue(Value: Currency);
  public
    { Déclarations publiques }
    property Valeur: Currency read FValeur write SetValue;
  end;

var
  FrmConvers: TFrmConvers;

implementation

uses CommonConst, EntitiesLite, UdmPrinc, UIB, Commun, DaoLite;

{$R *.DFM}

procedure TFrmConvers.FormCreate(Sender: TObject);
var
  q: TUIBQuery;
  fc: TframConvertisseur;
  PC: TConversionLite;
  i: Integer;
begin
  FFirstEdit := nil;
  ListFC := TList<TframConvertisseur>.Create;
  PC := TConversionLite.Create;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT Monnaie1, Monnaie2, Taux FROM conversions WHERE Monnaie1 = ? OR Monnaie2 = ?';
      Prepare(True);
      Params.AsString[0] := Copy(TGlobalVar.Utilisateur.Options.SymboleMonnetaire, 1, Params.MaxStrLen[0]);
      Params.AsString[1] := Copy(TGlobalVar.Utilisateur.Options.SymboleMonnetaire, 1, Params.MaxStrLen[1]);
      Open;
      i := 0;
      while not Eof do
      begin
        TDaoConversionLite.Fill(PC, q);
        fc := TframConvertisseur.Create(Self);
        if PC.Monnaie1 = TGlobalVar.Utilisateur.Options.SymboleMonnetaire then
        begin
          fc.Label1.Caption := PC.Monnaie2;
          fc.FTaux := 1 / PC.Taux;
        end
        else
        begin
          fc.Label1.Caption := PC.Monnaie1;
          fc.FTaux := PC.Taux;
        end;
        fc.Edit1.Text := '';
        fc.Visible := True;
        fc.Parent := Panel1;
        fc.Name := fc.Name + IntToStr(i);
        ListFC.Add(fc);
        Inc(i, fc.Height);
        if not Assigned(FFirstEdit) then
          FFirstEdit := fc.Edit1;
        Next;
      end;
      ClientHeight := Frame11.Height + i + 4;
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
  fc: TframConvertisseur;
begin
  for i := 0 to ListFC.Count - 1 do
  begin
    fc := TframConvertisseur(ListFC[i]);
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
  if Assigned(FFirstEdit) then
    FFirstEdit.SetFocus;
end;

end.
