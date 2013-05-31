unit DM_WS_Princ;

interface

uses
  SysUtils, Classes, HTTPApp, WebModu, ReqMulti, JvUIB, WebUsers, WebSess,
  WebDisp, WebAdapt, WebComp, Forms, HTTPProd;

type
  TWS_DMPrinc = class(TWebAppDataModule)
    WebAppComponents: TWebAppComponents;
    ApplicationAdapter: TApplicationAdapter;
    PageDispatcher: TPageDispatcher;
    AdapterDispatcher: TAdapterDispatcher;
    Copyright: TAdapterField;
    Title: TAdapterApplicationTitleField;
    Version: TAdapterField;
    PageProducer: TPageProducer;
    WSVersion: TAdapterField;
    procedure WebAppDataModuleCreate(Sender: TObject);
    procedure CopyrightGetValue(Sender: TObject; var Value: Variant);
    procedure VersionGetValue(Sender: TObject; var Value: Variant);
    procedure PageDispatcherPageNotFound(Sender: TObject; const PageName: string; var Handled: Boolean);
  private
    { déclarations privées }
  public
    { déclarations publiques }
    UIBDataBase: TJvUIBDataBase;
  end;

function WS_DMPrinc: TWS_DMPrinc;

implementation

{$R *.dfm}

uses WebReq, WebCntxt, WebFact, Variants, IniFiles, CommonConst, Divers;

function WS_DMPrinc: TWS_DMPrinc;
begin
  Result := TWS_DMPrinc(WebContext.FindModuleClass(TWS_DMPrinc));
end;

procedure TWS_DMPrinc.WebAppDataModuleCreate(Sender: TObject);
begin
  ApplicationAdapter.ApplicationTitle := TitreApplication;
end;

procedure TWS_DMPrinc.CopyrightGetValue(Sender: TObject; var Value: Variant);
begin
  Value := CopyrightTetramCorp;
end;

procedure TWS_DMPrinc.VersionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GetFichierVersion(Application.ExeName);
end;

procedure TWS_DMPrinc.PageDispatcherPageNotFound(Sender: TObject; const PageName: string; var Handled: Boolean);
begin
  PageProducer.HTMLFile := WebServerPath + PageName + '.html';
  Response.ContentType := 'text/html';
  Response.Content := PageProducer.Content;
  Handled := True;
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebAppDataModuleFactory.Create(TWS_DMPrinc, caCache));

end.
