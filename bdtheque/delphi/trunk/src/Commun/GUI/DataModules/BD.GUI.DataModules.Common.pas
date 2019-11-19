unit BD.GUI.DataModules.Common;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls,
  PngImageList;

type
  TdmCommon = class(TDataModule)
    ShareImageList: TPngImageList;
  end;

var
  dmCommon: TdmCommon;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
