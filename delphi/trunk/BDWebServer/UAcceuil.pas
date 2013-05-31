unit UAcceuil;

interface

uses
  SysUtils, Classes, HTTPApp, WebModu, HTTPProd, Procedures;

type
  TAcceuil = class(TWebPageModule)
    PageProducer: TPageProducer;
    procedure WebPageModuleCreate(Sender: TObject);
    procedure WebPageModuleBeforeDispatchPage(Sender: TObject;
      const PageName: string; var Handled: Boolean);
  private
    { déclarations privées }
  public
    { déclarations publiques }
  end;

function Acceuil: TAcceuil;

implementation

{$R *.dfm}

uses WebReq, WebCntxt, WebFact, Variants, CommonConst;

function Acceuil: TAcceuil;
begin
  Result := TAcceuil(WebContext.FindModuleClass(TAcceuil));
end;

procedure TAcceuil.WebPageModuleCreate(Sender: TObject);
begin
  PageProducer.HTMLFile := WebServerPath + Name + '.html';
end;

procedure TAcceuil.WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
var
  Modele: string;
begin
  Modele := Request.QueryFields.Values['Modele'];
  if Modele <> '' then
    PageProducer.HTMLFile := WebServerPath + Modele + '.html'
  else
    PageProducer.HTMLFile := WebServerPath + PageName + '.html';
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebPageModuleFactory.Create(TAcceuil, TWebPageInfo.Create([wpPublished {, wpLoginRequired}], ''), crOnDemand, caDestroy));

end.
