unit UAffiche;

interface

uses
  SysUtils, Classes, HTTPApp, WebModu, HTTPProd, WebAdapt, WebComp;

type
  TAffiche = class(TWebPageModule)
    PageProducer: TPageProducer;
    Adapter1: TAdapter;
  private
    { déclarations privées }
  public
    { déclarations publiques }
  end;

function Affiche: TAffiche;

implementation

{$R *.dfm}

uses WebReq, WebCntxt, WebFact, Variants;

function Affiche: TAffiche;
begin
  Result := TAffiche(WebContext.FindModuleClass(TAffiche));
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebPageModuleFactory.Create(TAffiche, TWebPageInfo.Create([wpPublished {, wpLoginRequired}], ''), crOnDemand, caCache)

      );

end.
