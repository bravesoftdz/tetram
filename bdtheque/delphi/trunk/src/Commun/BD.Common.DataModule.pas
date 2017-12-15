unit BD.Common.DataModule;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls,
  PngImageList;

type
  TdmCommon = class(TDataModule)
    ShareImageList: TPngImageList;
  private
    class function getInstance: TdmCommon;
  strict private
    class var _instance: TdmCommon;
  public
  end;

function dmCommon: TdmCommon;

implementation

uses
  System.SyncObjs, Vcl.Forms;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function dmCommon: TdmCommon;
begin
  Result := TdmCommon.getInstance;
end;

{ TdmCommon }

class function TdmCommon.getInstance: TdmCommon;
var
  cs: TCriticalSection;
begin
  if not Assigned(_instance) then
  begin
    cs := TCriticalSection.Create;
    cs.Enter;
    try
      Application.CreateForm(TdmCommon, _instance);
    finally
      cs.Leave;
      cs.Free;
    end;
  end;
  Result := _instance;
end;

end.
