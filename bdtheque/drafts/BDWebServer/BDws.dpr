library BDws;

{%File '..\WebServer\FicheSerie.html'}
{%File '..\WebServer\Fond.html'}
{%File '..\WebServer\Repertoire.html'}
{%File '..\WebServer\RepInitiales.html'}
{%File '..\WebServer\Styles.css'}
{%File '..\WebServer\Acceuil.html'}
{%File '..\WebServer\FicheAlbum.html'}
{%File '..\WebServer\FichePersonne.html'}
{%File '..\WebServer\Previsions.html'}
{%File '..\WebServer\Manquants.html'}

uses
  ActiveX,
  ComObj,
  WebBroker,
  ISAPIThreadPool,
  ISAPIApp,
  DM_Princ in 'DM_Princ.pas' {DMPrinc: TWebAppDataModule},
  CommonConst in '..\Sources\CommonConst.pas',
  Divers in '..\..\..\Common\Divers.pas',
  LoadComplet in '..\Sources\LoadComplet.pas',
  TypeRec in '..\Sources\TypeRec.pas',
  Commun in '..\Sources\Commun.pas',
  Procedures in 'Procedures.pas',
  UAcceuil in 'UAcceuil.pas' {Acceuil: TWebPageModule},
  UPrevisions in 'UPrevisions.pas' {Previsions: TWebPageModule},
  UFicheAlbum in 'UFicheAlbum.pas' {FicheAlbum: TWebPageModule},
  UFichePersonne in 'UFichePersonne.pas' {FichePersonne: TWebPageModule},
  UFicheSerie in 'UFicheSerie.pas' {FicheSerie: TWebPageModule},
  URepertoire in 'URepertoire.pas' {Repertoire: TWebPageModule},
  UManquants in 'UManquants.pas' {Manquants: TWebPageModule};

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  CoInitFlags := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.Run;
end.
