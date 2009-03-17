program BD;

{$R 'ressources.res' 'ressources.rc'}
{$R 'scripts_maj.res' 'mises à jour\scripts_maj.rc'}

uses
  FastMM4,
  Windows,
  SysUtils,
  Forms,
  Controls,
  Dialogs,
  SyncObjs,
  Divers,
  DateUtils,
  CommonConst in 'CommonConst.pas',
  Commun in 'Commun.pas',
  UfrmFond in 'UfrmFond.pas' {frmFond},
  DM_Princ in 'DM_Princ.pas' {DMPrinc: TDataModule},
  Form_Repertoire in 'Consultation\Form_Repertoire.pas' {FrmRepertoire},
  Form_ConsultationAlbum in 'Consultation\Form_ConsultationAlbum.pas' {FrmConsultationAlbum},
  Form_ConsultationAuteur in 'Consultation\Form_ConsultationAuteur.pas' {FrmConsultationAuteur},
  Form_ConsultationEmprunteur in 'Consultation\Form_ConsultationEmprunteur.pas' {FrmConsultationEmprunteur},
  Form_ConsultationSerie in 'Consultation\Form_ConsultationSerie.pas' {FrmConsultationSerie},
  Form_ConsultationParaBD in 'Consultation\Form_ConsultationParaBD.pas' {FrmConsultationParaBD},
  Form_ZoomCouverture in 'Consultation\Form_ZoomCouverture.pas' {FrmZoomCouverture},
  Form_Recherche in 'Consultation\Form_Recherche.pas' {FrmRecherche},
  Form_EditCritereTri in 'Consultation\Form_EditCritereTri.pas' {FrmEditCritereTri},
  Form_Stock in 'Consultation\Form_Stock.pas' {FrmStock},
  Form_SaisieEmpruntAlbum in 'Consultation\Form_SaisieEmpruntAlbum.pas' {FrmSaisie_EmpruntAlbum},
  Form_SaisieEmpruntEmprunteur in 'Consultation\Form_SaisieEmpruntEmprunteur.pas' {FrmSaisie_EmpruntEmprunteur},
  Form_StatsGeneral in 'Consultation\Form_StatsGeneral.pas' {FrmStatsGenerales},
  Form_StatsEmprunteurs in 'Consultation\Form_StatsEmprunteurs.pas' {FrmStatsEmprunteurs},
  Form_StatsAlbums in 'Consultation\Form_StatsAlbums.pas' {FrmStatsAlbums},
  DM_Commun in 'DM_Commun.pas' {DataCommun: TDataModule},
  Editions in 'Gestion\Editions.pas',
  Proc_Gestions in 'Gestion\Proc_Gestions.pas',
  Form_Gestion in 'Gestion\Form_Gestion.pas' {FrmGestions},
  Form_EditAlbum in 'Gestion\Form_EditAlbum.pas' {FrmEditAlbum},
  Form_EditAchatAlbum in 'Gestion\Form_EditAchatAlbum.pas' {FrmEditAchatAlbum},
  Form_EditEditeur in 'Gestion\Form_EditEditeur.pas' {FrmEditEditeur},
  Form_EditCollection in 'Gestion\Form_EditCollection.pas' {FrmEditCollection},
  Form_EditAuteur in 'Gestion\Form_EditAuteur.pas' {FrmEditAuteur},
  Form_EditEmprunteur in 'Gestion\Form_EditEmprunteur.pas' {FrmEditEmprunteur},
  Form_EditParaBD in 'Gestion\Form_EditParaBD.pas' {FrmEditParaBD},
  Textes in 'Textes.pas',
  LoadComplet in 'LoadComplet.pas',
  Impression in 'Consultation\Impression.pas',
  Fram_Boutons in 'Fram_Boutons.pas' {Frame1: TFrame},
  Form_Options in 'Form_Options.pas' {FrmOptions},
  Form_Customize in 'Form_Customize.pas' {FrmCustomize},
  Form_Progression in 'Form_Progression.pas' {FrmProgression},
  Form_Splash in 'Form_Splash.pas' {FrmSplash},
  Form_AboutBox in 'Form_AboutBox.pas' {FrmAboutBox},
  Form_Choix in 'Form_Choix.pas' {FrmChoix},
  Form_ChoixDetail in 'Form_ChoixDetail.pas' {FrmChoixDetail},
  Form_Convertisseur in 'Form_Convertisseur.pas' {FrmConvers},
  Frame_Convertisseur in 'Frame_Convertisseur.pas' {Convertisseur: TFrame},
  Frame_RechercheRapide in 'Frame_RechercheRapide.pas' {FrameRechercheRapide: TFrame},
  MAJ in 'Consultation\MAJ.pas',
  TypeRec in 'TypeRec.pas',
  VirtualTree in 'VirtualTree.pas',
  Form_Preview in 'Consultation\Form_Preview.pas' {FrmPreview},
  Procedures in 'Procedures.pas',
  UHistorique in 'UHistorique.pas',
  Form_Verbose in 'Form_Verbose.pas' {FrmVerbose},
  Form_Entretien in 'Form_Entretien.pas' {FrmEntretien},
  Form_Exportation in 'Gestion\Form_Exportation.pas' {FrmExportation},
  Form_PrevisionsSorties in 'Consultation\Form_PrevisionsSorties.pas' {frmPrevisionsSorties},
  Form_SeriesIncompletes in 'Consultation\Form_SeriesIncompletes.pas' {frmSeriesIncompletes},
  Form_PrevisionAchats in 'Consultation\Form_PrevisionAchats.pas' {frmPrevisionsAchats},
  Updates in 'mises à jour\Updates.pas',
  UMAJ0_0_0_6 in 'mises à jour\UMAJ0_0_0_6.pas',
  UMAJ0_0_0_8 in 'mises à jour\UMAJ0_0_0_8.pas',
  UMAJ0_0_0_9 in 'mises à jour\UMAJ0_0_0_9.pas',
  UMAJ0_0_1_2 in 'mises à jour\UMAJ0_0_1_2.pas',
  UMAJ0_0_1_7 in 'mises à jour\UMAJ0_0_1_7.pas',
  UMAJ0_0_2_2 in 'mises à jour\UMAJ0_0_2_2.pas',
  UMAJ0_0_2_3 in 'mises à jour\UMAJ0_0_2_3.pas',
  UMAJ0_0_2_5 in 'mises à jour\UMAJ0_0_2_5.pas',
  UMAJ0_0_2_7 in 'mises à jour\UMAJ0_0_2_7.pas',
  UMAJ0_0_2_19 in 'mises à jour\UMAJ0_0_2_19.pas',
  UMAJ0_0_2_23 in 'mises à jour\UMAJ0_0_2_23.pas',
  UMAJ0_0_3_01 in 'mises à jour\UMAJ0_0_3_01.pas',
  UMAJ0_0_3_02 in 'mises à jour\UMAJ0_0_3_02.pas',
  UMAJ0_0_3_07 in 'mises à jour\UMAJ0_0_3_07.pas',
  UMAJ0_0_3_14 in 'mises à jour\UMAJ0_0_3_14.pas',
  UMAJ0_0_3_16 in 'mises à jour\UMAJ0_0_3_16.pas',
  UMAJ0_0_3_19 in 'mises à jour\UMAJ0_0_3_19.pas',
  UMAJ0_0_3_21 in 'mises à jour\UMAJ0_0_3_21.pas',
  UMAJ0_0_3_22 in 'mises à jour\UMAJ0_0_3_22.pas',
  UMAJ0_0_3_23 in 'mises à jour\UMAJ0_0_3_23.pas',
  UMAJ0_0_3_24 in 'mises à jour\UMAJ0_0_3_24.pas',
  UMAJ0_0_3_25 in 'mises à jour\UMAJ0_0_3_25.pas',
  UMAJ0_0_3_27 in 'mises à jour\UMAJ0_0_3_27.pas',
  UMAJ1_0_0_0 in 'mises à jour\UMAJ1_0_0_0.pas',
  UMAJ1_0_0_2 in 'mises à jour\UMAJ1_0_0_2.pas',
  UMAJ1_0_0_3 in 'mises à jour\UMAJ1_0_0_3.pas',
  UMAJ1_1_0_0 in 'mises à jour\UMAJ1_1_0_0.pas',
  UMAJ1_2_0_0 in 'mises à jour\UMAJ1_2_0_0.pas',
  UMAJ1_2_0_8 in 'mises à jour\UMAJ1_2_0_8.pas',
  UMAJ1_2_1_0 in 'mises à jour\UMAJ1_2_1_0.pas',
  UMAJ1_2_2_0 in 'mises à jour\UMAJ1_2_2_0.pas',
  ListOfTypeRec in 'ListOfTypeRec.pas',
  Form_WizardImport in 'Gestion\Form_WizardImport.pas' {WizardImport},
  UImportXML in 'Gestion\UImportXML.pas',
  ProceduresBDtk in 'ProceduresBDtk.pas',
  UMAJ1_2_3_14 in 'mises à jour\UMAJ1_2_3_14.pas',
  Form_ChoixDetailSerie in 'Form_ChoixDetailSerie.pas' {FrmChoixDetailSerie},
  UMAJ1_2_3_25 in 'mises à jour\UMAJ1_2_3_25.pas',
  UMAJ2_1_0_16 in 'mises à jour\UMAJ2_1_0_16.pas',
  UMAJ1_2_3_20 in 'mises à jour\UMAJ1_2_3_20.pas',
  UMAJ1_2_3_22 in 'mises à jour\UMAJ1_2_3_22.pas',
  UMAJ1_2_3_26 in 'mises à jour\UMAJ1_2_3_26.pas',
  UMAJODS in 'mises à jour\UMAJODS.pas',
  Form_EditCritere in 'Consultation\Form_EditCritere.pas' {FrmEditCritere},
  UChampsRecherche in 'Consultation\UChampsRecherche.pas',
  UBdtForms in 'UBdtForms.pas',
  UMAJ2_0_0_5 in 'mises à jour\UMAJ2_0_0_5.pas',
  Form_Publier in 'Web\Form_Publier.pas' {frmPublier},
  UNet in 'Web\UNet.pas',
  UMySQLMAJ1_0_0_1 in 'Web\mises à jour\UMySQLMAJ1_0_0_1.pas',
  DIMimeStreams in 'Web\Mime64\DIMimeStreams.pas',
  DIMime in 'Web\Mime64\DIMime.pas',
  UMAJ2_0_1_0 in 'mises à jour\UMAJ2_0_1_0.pas',
  Form_Fusion in 'Form_Fusion.pas' {frmFusion},
  UMAJ2_1_0_0 in 'mises à jour\UMAJ2_1_0_0.pas',
  UMySQLMAJ1_0_0_0 in 'Web\mises à jour\UMySQLMAJ1_0_0_0.pas',
  UMySQLMAJ1_0_0_2 in 'Web\mises à jour\UMySQLMAJ1_0_0_2.pas',
  UMAJ2_1_0_22 in 'mises à jour\UMAJ2_1_0_22.pas',
  UMAJ2_1_0_72 in 'mises à jour\UMAJ2_1_0_72.pas',
  DM_Scripts in 'Scripts\DM_Scripts.pas' {DMScripts: TDataModule},
  Form_Scripts in 'Scripts\Form_Scripts.pas' {frmScripts},
  Form_ScriptSearch in 'Scripts\Form_ScriptSearch.pas' {Form2},
  IDHashMap in 'Scripts\IDHashMap.pas',
  uPSC_BdtkObjects in 'Scripts\uPSC_BdtkObjects.pas',
  uPSI_BdtkObjects in 'Scripts\uPSI_BdtkObjects.pas',
  uPSR_BdtkObjects in 'Scripts\uPSR_BdtkObjects.pas',
  UScriptsFonctions in 'Scripts\UScriptsFonctions.pas',
  UScriptUtils in 'Scripts\UScriptUtils.pas',
  uPSC_BdtkRegEx in 'Scripts\uPSC_BdtkRegEx.pas',
  uPSI_BdtkRegEx in 'Scripts\uPSI_BdtkRegEx.pas',
  uPSR_BdtkRegEx in 'Scripts\uPSR_BdtkRegEx.pas',
  BdtkRegEx in 'Scripts\BdtkRegEx.pas',
  UMetadata in 'UMetadata.pas',
  Form_ControlImport in 'Gestion\Form_ControlImport.pas' {frmControlImport},
  UVirtualTreeEdit in 'UVirtualTreeEdit.pas',
  UframVTEdit in 'UframVTEdit.pas' {framVTEdit: TFrame},
  Form_EditSerie in 'Gestion\Form_EditSerie.pas' {FrmEditSerie};

{$R *.RES}
{$R curseurs.res}
{$INCLUDE FastMM4Options.inc}

var
  Debut: TDateTime;
begin
  TGlobalVar.Mode_en_cours := mdLoad;
  Application.Title := 'BDthèque';
  if not Bool(CreateMutex(nil, True, 'TetramCorpBDMutex')) then
    RaiseLastOSError
  else if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ShowMessage('Une instance de BDthèque est déjà ouverte!');
    Exit;
  end;

  //  if not CheckCriticalFiles then Halt;

  FrmSplash := TFrmSplash.Create(nil);
  try
    FrmSplash.Show;
    Application.ProcessMessages;
    Debut := now;

    FrmSplash.Affiche_act(VerificationVersion + '...');
    if DMPrinc.CheckVersion(False) then
      Exit;
    if not OuvreSession then
      Exit;
    if not DMPrinc.CheckVersions(FrmSplash.Affiche_act) then
      Exit;

    FrmSplash.Affiche_act(ChargementOptions + '...');
    LitOptions;

    FrmSplash.Affiche_act(ChargementApp + '...');
    Application.CreateForm(TfrmFond, frmFond);
  FrmSplash.Affiche_act(ChargementDatabase + '...');
    Historique.AddConsultation(fcRecherche);
    if FindCmdLineSwitch('scripts') then
      frmFond.actScripts.Execute
    else
    begin
      if TGlobalVar.Utilisateur.Options.ModeDemarrage then
        frmFond.actModeConsultation.Execute
      else
        frmFond.actModeGestion.Execute;
    end;

    FrmSplash.Affiche_act(FinChargement + '...');
    ChangeCurseur(crHandPoint, 'MyHandPoint', 'MyCursor');
    while SecondsBetween(Now, Debut) < 1 do // au moins 1 seconde d'affichage du splash
    begin
      FrmSplash.Show;
      FrmSplash.Update;
    end;
  finally
    FrmSplash.Free;
  end;
  // Fond.Show
  Application.MainForm.Show;
  Application.Run;
end.

