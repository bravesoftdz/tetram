unit Form_ConsultationParaBD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LoadComplet;

type
  TFrmConsultationParaBD = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FParaBD: TParaBDComplet;
    function GetRefParaBD: Integer;
    procedure SetRefParaBD(const Value: Integer);
    procedure ClearForm;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property ParaBD: TParaBDComplet read FParaBD;
    property RefParaBD: Integer read GetRefParaBD write SetRefParaBD;
  end;

implementation

{$R *.dfm}

{ TFrmConsultationParaBD }

function TFrmConsultationParaBD.GetRefParaBD: Integer;
begin
  Result := FParaBD.RefParaBD;
end;

procedure TFrmConsultationParaBD.SetRefParaBD(const Value: Integer);
begin
  ClearForm;
  FParaBD.Fill(Value);

end;

procedure TFrmConsultationParaBD.ClearForm;
begin

end;

procedure TFrmConsultationParaBD.FormCreate(Sender: TObject);
begin
  FParaBD := TParaBDComplet.Create;
end;

procedure TFrmConsultationParaBD.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FParaBD.Free;
end;

end.
