unit DM_Princ;

interface

uses
  SysUtils, Classes, HTTPApp, WebModu, ReqMulti, JvUIB, WebUsers, WebSess,
  WebDisp, WebAdapt, WebComp, Forms, HTTPProd;

type
  TDMPrinc = class(TWebAppDataModule)
    WebAppComponents: TWebAppComponents;
    ApplicationAdapter: TApplicationAdapter;
    EndUserAdapter: TEndUserAdapter;
    PageDispatcher: TPageDispatcher;
    AdapterDispatcher: TAdapterDispatcher;
    Copyright: TAdapterField;
    Title: TAdapterApplicationTitleField;
    Version: TAdapterField;
    WSVersion: TAdapterField;
    PageProducer: TPageProducer;
    procedure WebAppDataModuleCreate(Sender: TObject);
    procedure CopyrightGetValue(Sender: TObject; var Value: Variant);
    procedure WSVersionGetValue(Sender: TObject; var Value: Variant);
    procedure VersionGetValue(Sender: TObject; var Value: Variant);
    procedure PageDispatcherPageNotFound(Sender: TObject; const PageName: String; var Handled: Boolean);
  private
    { déclarations privées }
  public
    { déclarations publiques }
    UIBDataBase: TJvUIBDataBase;
  end;

  function DMPrinc: TDMPrinc;

implementation

{$R *.dfm} 

uses WebReq, WebCntxt, WebFact, Variants, IniFiles, CommonConst, Divers;

function DMPrinc: TDMPrinc;
begin
  Result := TDMPrinc(WebContext.FindModuleClass(TDMPrinc));
end;

procedure TDMPrinc.WebAppDataModuleCreate(Sender: TObject);
begin
  ApplicationAdapter.ApplicationTitle := TitreApplication;
end;

procedure TDMPrinc.CopyrightGetValue(Sender: TObject; var Value: Variant);
begin
  Value := CopyrightTetramCorp;
end;

procedure TDMPrinc.WSVersionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GetFichierVersion(WebServerDll);
end;

procedure TDMPrinc.VersionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GetFichierVersion(Application.ExeName);
end;

procedure TDMPrinc.PageDispatcherPageNotFound(Sender: TObject; const PageName: String; var Handled: Boolean);
begin
  PageProducer.HTMLFile := WebServerPath + PageName + '.html';
  Response.ContentType := 'text/html';
  Response.Content := PageProducer.Content;
  Handled := True;
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebAppDataModuleFactory.Create(TDMPrinc, caCache));

end.

