unit BDTK.GUI.Forms.Converter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  BD.GUI.Frames.Buttons, BD.GUI.Forms, System.Generics.Collections,
  BDTK.GUI.Frames.Converter;

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

uses BD.Common, BD.Entities.Lite, BDTK.GUI.DataModules.Main, UIB, BD.Utils.StrUtils, BDTK.Entities.Dao.Lite,
  BD.Entities.Factory.Lite, BD.DB.Connection;

{$R *.DFM}

procedure TFrmConvers.FormCreate(Sender: TObject);
var
  q: TManagedQuery;
  fc: TframConvertisseur;
  PC: TConversionLite;
  i: Integer;
begin
  FFirstEdit := nil;
  ListFC := TList<TframConvertisseur>.Create;
  PC := TFactoryConversionLite.getInstance;
  q := dmPrinc.DBConnection.GetQuery;
  try
    q.SQL.Add('select');
    q.SQL.Add('  Monnaie1, Monnaie2, Taux');
    q.SQL.Add('from');
    q.SQL.Add('  conversions');
    q.SQL.Add('where');
    q.SQL.Add('  Monnaie1 = ? or Monnaie2 = ?');
    q.SQL.Add('order by');
    q.SQL.Add('  case Monnaie1 when ? then Monnaie2 else Monnaie1 end');
    q.Prepare(True);
    q.Params.AsString[0] := Copy(TGlobalVar.Options.SymboleMonnetaire, 1, q.Params.MaxStrLen[0]);
    q.Params.AsString[1] := Copy(TGlobalVar.Options.SymboleMonnetaire, 1, q.Params.MaxStrLen[1]);
    q.Params.AsString[2] := Copy(TGlobalVar.Options.SymboleMonnetaire, 1, q.Params.MaxStrLen[2]);
    q.Open;
    i := 0;
    while not q.Eof do
    begin
      TDaoConversionLite.Fill(PC, q);
      fc := TframConvertisseur.Create(Self);
      if PC.Monnaie1 = TGlobalVar.Options.SymboleMonnetaire then
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
      q.Next;
    end;
    ClientHeight := Frame11.Height + i + 4;
  finally
    ActiveControl := FFirstEdit;
    q.Free;
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
