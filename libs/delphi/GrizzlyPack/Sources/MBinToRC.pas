unit MBinToRC;

interface

uses
  SysUtils, Classes, ResStore;

type
  TDMBinToRC = class(TDataModule)
    ExeStore: TRessourceStore;
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  DMBinToRC: TDMBinToRC;

implementation

{$R *.dfm}

end.
