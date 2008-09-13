unit UBdtForms;

interface

uses Classes, Forms;

type
  TbdtForm = class(TForm)
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer); override;
  end;

implementation

{$R *.DFM}

{ TbdtForm }

constructor TbdtForm.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited;
  Scaled := False;
end;

end.
