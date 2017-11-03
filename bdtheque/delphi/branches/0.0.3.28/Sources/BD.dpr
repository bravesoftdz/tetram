program BD;

{%File '..\..\..\..\Thierry\MonSite\bdtheque\TodoList.txt'}
{$R 'webserver.res' 'webserver.rc'}
{$R 'ressources.res' 'ressources.rc'}

uses
  Windows,
  SysUtils,
  Forms,
  Controls,
  Dialogs,
  ISAPIApp,
  CommonConst in 'CommonConst.pas',
  Commun in 'Commun.pas',
  Main in 'Main.pas' {Fond},
  DM_Princ in 'DM_Princ.pas' {DMPrinc: TDataModule},
  Form_Repertoire in 'Form_Repertoire.pas' {FrmRepertoire},
  Form_Consultation in 'Form_Consultation.pas' {FrmConsultation},
  Form_ConsultationAuteur in 'Form_ConsultationAuteur.pas' {FrmConsultationAuteur},
  Form_ConsultationE in 'Form_ConsultationE.pas' {FrmConsultationE},
  Form_ZoomCouverture in 'Form_ZoomCouverture.pas' {FrmZoomCouverture},
  Form_Recherche in 'Form_Recherche.pas' {FrmRecherche},
  Form_EditCritere in 'Form_EditCritere.pas' {FrmEditCritere},
  Form_Stock in 'Form_Stock.pas' {FrmStock},
  Form_SaisieEmpruntAlbum in 'Form_SaisieEmpruntAlbum.pas' {FrmSaisie_EmpruntAlbum},
  Form_SaisieEmpruntEmprunteur in 'Form_SaisieEmpruntEmprunteur.pas' {FrmSaisie_EmpruntEmprunteur},
  Form_StatsGeneral in 'Form_StatsGeneral.pas' {FrmStatsGenerales},
  Form_StatsEmprunteurs in 'Form_StatsEmprunteurs.pas' {FrmStatsEmprunteurs},
  Form_StatsAlbums in 'Form_StatsAlbums.pas' {FrmStatsAlbums},
  DM_Commun in 'DM_Commun.pas' {DataCommun: TDataModule},
  Editions in 'Editions.pas',
  Proc_Gestions in 'Proc_Gestions.pas',
  Form_Gestion in 'Form_Gestion.pas' {FrmGestions},
  Form_EditAlbum in 'Form_EditAlbum.pas' {FrmEditAlbum},
  Form_EditAchat in 'Form_EditAchat.pas' {FrmEditAchat},
  Form_EditSerie in 'Form_EditSerie.pas' {FrmEditSerie},
  Form_EditEditeur in 'Form_EditEditeur.pas' {FrmEditEditeur},
  Form_EditCollection in 'Form_EditCollection.pas' {FrmEditCollection},
  Form_EditAuteur in 'Form_EditAuteur.pas' {FrmEditAuteur},
  Form_EditEmprunteur in 'Form_EditEmprunteur.pas' {FrmEditEmprunteur},
  Textes in 'Textes.pas',
  LoadComplet in 'LoadComplet.pas',
  Impression in 'Impression.pas',
  Fram_Boutons in 'Fram_Boutons.pas' {Frame1: TFrame},
  Form_options in 'Form_Options.pas' {FrmOptions},
  Form_Customize in 'Form_Customize.pas' {FrmCustomize},
  Form_Progression in 'Form_Progression.pas' {FrmProgression},
  Form_Splash in 'Form_Splash.pas' {FrmSplash},
  Form_AboutBox in 'Form_AboutBox.pas' {FrmAboutBox},
  Form_Choix in 'Form_Choix.pas' {FrmChoix},
  Form_ChoixDetail in 'Form_ChoixDetail.pas' {FrmChoixDetail},
  Form_Convertisseur in 'Form_Convertisseur.pas' {FrmConvers},
  Frame_Convertisseur in 'Frame_Convertisseur.pas' {Convertisseur: TFrame},
  CommonList in 'CommonList.pas',
  MAJ in 'MAJ.pas',
  TypeRec in 'TypeRec.pas',
  Divers in '..\..\..\Common\Divers.pas',
  VirtualTree in 'VirtualTree.pas',
  Form_Preview in 'Form_Preview.pas' {FrmPreview},
  Procedures in 'Procedures.pas',
  UHistorique in 'UHistorique.pas',
  Form_Verbose in 'Form_Verbose.pas' {FrmVerbose},
  Form_Entretien in 'Form_Entretien.pas' {FrmEntretien},
  Form_Exportation in 'Form_Exportation.pas' {FrmExportation},
  Form_PrevisionsSorties in 'Form_PrevisionsSorties.pas' {frmPrevisionsSorties},
  Form_SeriesIncompletes in 'Form_SeriesIncompletes.pas' {frmSeriesIncompletes},
  Form_PrevisionAchats in 'Form_PrevisionAchats.pas' {frmPrevisionsAchats},
  DM_WS_Princ in '..\Sources BDWebServer\DM_WS_Princ.pas' {WS_DMPrinc: TWebAppDataModule},
  URepertoire in '..\Sources BDWebServer\URepertoire.pas' {Repertoire: TWebPageModule},
  UAcceuil in '..\Sources BDWebServer\UAcceuil.pas' {Acceuil: TWebPageModule},
  UAffiche in '..\Sources BDWebServer\UAffiche.pas' {Affiche: TWebPageModule},
  UFicheAlbum in '..\Sources BDWebServer\UFicheAlbum.pas' {FicheAlbum: TWebPageModule},
  UFichePersonne in '..\Sources BDWebServer\UFichePersonne.pas' {FichePersonne: TWebPageModule},
  UFicheSerie in '..\Sources BDWebServer\UFicheSerie.pas' {FicheSerie: TWebPageModule},
  UManquants in '..\Sources BDWebServer\UManquants.pas' {Manquants: TWebPageModule},
  UPrevisions in '..\Sources BDWebServer\UPrevisions.pas' {Previsions: TWebPageModule},
  Updates in 'Updates.pas',
  idISAPIRunner in '..\..\..\Compos Perso\idrunner\idISAPIRunner.pas',
  UMAJ0_0_0_6 in 'UMAJ0_0_0_6.pas',
  UMAJ0_0_0_8 in 'UMAJ0_0_0_8.pas',
  UMAJ0_0_0_9 in 'UMAJ0_0_0_9.pas',
  UMAJ0_0_1_2 in 'UMAJ0_0_1_2.pas',
  UMAJ0_0_1_7 in 'UMAJ0_0_1_7.pas',
  UMAJ0_0_2_2 in 'UMAJ0_0_2_2.pas',
  UMAJ0_0_2_3 in 'UMAJ0_0_2_3.pas',
  UMAJ0_0_2_5 in 'UMAJ0_0_2_5.pas',
  UMAJ0_0_2_7 in 'UMAJ0_0_2_7.pas',
  UMAJ0_0_2_19 in 'UMAJ0_0_2_19.pas',
  UMAJ0_0_2_23 in 'UMAJ0_0_2_23.pas',
  UMAJ0_0_3_01 in 'UMAJ0_0_3_01.pas',
  UMAJ0_0_3_02 in 'UMAJ0_0_3_02.pas',
  UMAJ0_0_3_07 in 'UMAJ0_0_3_07.pas',
  UMAJ0_0_3_16 in 'UMAJ0_0_3_16.pas',
  UMAJ0_0_3_14 in 'UMAJ0_0_3_14.pas',
  UMAJ0_0_3_19 in 'UMAJ0_0_3_19.pas',
  UMAJ0_0_3_21 in 'UMAJ0_0_3_21.pas',
  UMAJ0_0_3_22 in 'UMAJ0_0_3_22.pas',
  UMAJ0_0_3_23 in 'UMAJ0_0_3_23.pas',
  UMAJ0_0_3_24 in 'UMAJ0_0_3_24.pas',
  CheckVersionNet in '..\..\..\Common\CheckVersionNet.pas' {frmVerifUpgrade},
  UMAJ0_0_3_27 in 'UMAJ0_0_3_27.pas',
  UMAJ0_0_3_25 in 'UMAJ0_0_3_25.pas';

{$R *.RES}
{$R curseurs.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

const
  ChargementApp = 'Chargement de l''application';
  ChargementDatabase = 'Chargement des donn�es';
  ChargementOptions = 'Chargement des options';
  VerificationVersion = 'V�rification des versions';
  FinChargement = 'Fin du chargement';

var
  Debut: TDateTime;
begin
  Mode_en_cours := mdLoad;
  Application.Title := 'BDth�que';
  if not Bool(CreateMutex(nil, True, 'TetramCorpBDMutex')) then
    RaiseLastOSError
  else if GetLastError = ERROR_ALREADY_EXISTS then begin
    ShowMessage('Une instance de BDth�que est d�j� ouverte!');
    Exit;
  end;

  //  if not CheckCriticalFiles then Halt;

  FrmSplash := TFrmSplash.Create(nil);
  try
    FrmSplash.Show;
    Application.ProcessMessages;
    Debut := now;

    FrmSplash.Affiche_act(VerificationVersion + '...');
    if not (OuvreSession and DMPrinc.CheckVersions(FrmSplash.Affiche_act)) then Exit;

    FrmSplash.Affiche_act(ChargementOptions + '...');
    LitOptions;

    FrmSplash.Affiche_act(ChargementApp + '...');
    Application.CreateForm(TFond, Fond);
  FrmSplash.Affiche_act(ChargementDatabase + '...');
    Historique.AddConsultation(fcRecherche);
    if Utilisateur.Options.ModeDemarrage then
      Fond.ModeConsultation.Execute
    else
      Fond.ModeGestion.Execute;

    FrmSplash.Affiche_act(FinChargement + '...');
    ChangeCurseur(crHandPoint, 'MyHandPoint', 'MyCursor');
    while Now - Debut < (1 / (24 * 60 * 60)) * 1 do begin // 0: NoWait
      FrmSplash.BringToFront;
      FrmSplash.Show;
      FrmSplash.Update;
    end;
  finally
    FrmSplash.Free;
  end;
  Fond.Show;
  DMPrinc.ActiveHTTPServer(Utilisateur.Options.WebServerAutoStart);
  Application.Run;
end.

