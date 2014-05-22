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

uses CommonConst, Entities.Lite, UdmPrinc, UIB, Commun, Entities.DaoLite,
  Entities.FactoriesLite;

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
  PC := TFactoryConversionLite.getInstance;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Add('select');
      SQL.Add('  Monnaie1, Monnaie2, Taux');
      SQL.Add('from');
      SQL.Add('  conversions');
      SQL.Add('where');
      SQL.Add('  Monnaie1 = ? or Monnaie2 = ?');
      SQL.Add('order by');
      SQL.Add('  case Monnaie1 when ? then Monnaie2 else Monnaie1 end');
      Prepare(True);
      Params.AsString[0] := Copy(TGlobalVar.Utilisateur.Options.SymboleMonnetaire, 1, Params.MaxStrLen[0]);
      Params.AsString[1] := Copy(TGlobalVar.Utilisateur.Options.SymboleMonnetaire, 1, Params.MaxStrLen[1]);
      Params.AsString[2] := Copy(TGlobalVar.Utilisateur.Options.SymboleMonnetaire, 1, Params.MaxStrLen[2]);
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
        fc.Top := i + 1;

        if not Assigned(FFirstEdit) then
          FFirstEdit := fc.Edit1;
        Next;
      end;
      ClientHeight := Frame11.Height + i + 4;
    finally
      ActiveControl := FFirstEdit;
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
  fc: TframConvertisseur;
begin
  for fc in ListFC do
    try
      fc.Edit1.Text := BDDoubleToStr(Value / fc.FTaux);
    except
      fc.Edit1.Text := '';
    end;
  FValeur := Value;
end;

end.
