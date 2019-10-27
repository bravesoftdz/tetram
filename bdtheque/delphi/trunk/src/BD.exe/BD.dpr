program BD;

{$INCLUDE FastMM4Options.inc}

{$R *.dres}
{$R *.RES}

uses
  FastMM4,
  Windows,
  System.SysUtils,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.Dialogs,
  System.SyncObjs,
  Divers,
  System.DateUtils,
  BDTK.GUI.Forms.Main in 'GUI\Forms\BDTK.GUI.Forms.Main.pas' {frmFond},
  BDTK.GUI.DataModules.Main in 'GUI\DataModules\BDTK.GUI.DataModules.Main.pas' {dmPrinc: TDataModule},
  UfrmRepertoire in 'Consultation\UfrmRepertoire.pas' {frmRepertoire},
  UfrmConsultationAuteur in 'Consultation\UfrmConsultationAuteur.pas' {frmConsultationAuteur},
  UfrmConsultationSerie in 'Consultation\UfrmConsultationSerie.pas' {frmConsultationSerie},
  UfrmConsultationParaBD in 'Consultation\UfrmConsultationParaBD.pas' {frmConsultationParaBD},
  UfrmZoomCouverture in 'Consultation\UfrmZoomCouverture.pas' {frmZoomCouverture},
  UfrmRecherche in 'Consultation\UfrmRecherche.pas' {frmRecherche},
  UfrmEditCritereTri in 'Consultation\UfrmEditCritereTri.pas' {frmEditCritereTri},
  UfrmStatsGeneral in 'Consultation\UfrmStatsGeneral.pas' {frmStatsGenerales},
  UfrmStatsAlbums in 'Consultation\UfrmStatsAlbums.pas' {frmStatsAlbums},
  BDTK.GUI.DataModules.Search in 'GUI\DataModules\BDTK.GUI.DataModules.Search.pas' {dmSearch: TDataModule},
  Editions in 'Gestion\Editions.pas',
  Proc_Gestions in 'Gestion\Proc_Gestions.pas',
  UfrmGestion in 'Gestion\UfrmGestion.pas' {frmGestions},
  UfrmEditAlbum in 'Gestion\UfrmEditAlbum.pas' {frmEditAlbum},
  UfrmEditAchatAlbum in 'Gestion\UfrmEditAchatAlbum.pas' {frmEditAchatAlbum},
  UfrmEditEditeur in 'Gestion\UfrmEditEditeur.pas' {frmEditEditeur},
  UfrmEditSerie in 'Gestion\UfrmEditSerie.pas' {frmEditSerie},
  UfrmEditCollection in 'Gestion\UfrmEditCollection.pas' {frmEditCollection},
  UfrmEditAuteur in 'Gestion\UfrmEditAuteur.pas' {frmEditAuteur},
  UfrmEditParaBD in 'Gestion\UfrmEditParaBD.pas' {frmEditParaBD},
  Impression in 'Consultation\Impression.pas',
  BDTK.GUI.Forms.UserSettings in 'GUI\Forms\BDTK.GUI.Forms.UserSettings.pas' {frmOptions},
  BDTK.GUI.Forms.Customize in 'GUI\Forms\BDTK.GUI.Forms.Customize.pas' {frmCustomize},
  UfrmChoix in 'UfrmChoix.pas' {frmChoix},
  UfrmChoixDetail in 'UfrmChoixDetail.pas' {frmChoixDetail},
  BDTK.GUI.Forms.Converter in 'GUI\Forms\BDTK.GUI.Forms.Converter.pas' {FrmConvers},
  BDTK.GUI.Frames.Converter in 'GUI\Frames\BDTK.GUI.Frames.Converter.pas' {framConvertisseur: TFrame},
  BDTK.GUI.Frames.QuickSearch in 'GUI\Frames\BDTK.GUI.Frames.QuickSearch.pas' {framRechercheRapide: TFrame},
  MAJ in 'Consultation\MAJ.pas',
  UfrmPreview in 'Consultation\UfrmPreview.pas' {frmPreview},
  UHistorique in 'UHistorique.pas',
  UfrmEntretien in 'UfrmEntretien.pas' {frmEntretien},
  UfrmPrevisionsSorties in 'Consultation\UfrmPrevisionsSorties.pas' {frmPrevisionsSorties},
  UfrmSeriesIncompletes in 'Consultation\UfrmSeriesIncompletes.pas' {frmSeriesIncompletes},
  UfrmPrevisionAchats in 'Consultation\UfrmPrevisionAchats.pas' {frmPrevisionsAchats},
  BDTK.Updates in 'Updates\BDTK.Updates.pas',
  BDTK.GUI.Utils in 'GUI\BDTK.GUI.Utils.pas',
  UfrmChoixDetailSerie in 'UfrmChoixDetailSerie.pas' {frmChoixDetailSerie},
  BDTK.Updates.ODS in 'Updates\BDTK.Updates.ODS.pas',
  UfrmEditCritere in 'Consultation\UfrmEditCritere.pas' {frmEditCritere},
  UChampsRecherche in 'Consultation\UChampsRecherche.pas',
  BDTK.Web.Forms.Publish in 'Web\BDTK.Web.Forms.Publish.pas' {frmPublier},
  BDTK.Web.Updates.v1_0_0_1 in 'Web\Updates\BDTK.Web.Updates.v1_0_0_1.pas',
  BDTK.Web.Updates.v1_0_0_0 in 'Web\Updates\BDTK.Web.Updates.v1_0_0_0.pas',
  BDTK.Web.Updates.v1_0_0_2 in 'Web\Updates\BDTK.Web.Updates.v1_0_0_2.pas',
  UfrmControlImport in 'Gestion\UfrmControlImport.pas' {frmControlImport},
  BDTK.GUI.Controls.VirtualTreeEdit in 'GUI\Controls\BDTK.GUI.Controls.VirtualTreeEdit.pas',
  UframVTEdit in 'UframVTEdit.pas' {framVTEdit: TFrame},
  BDTK.Updates.v2_1_1_7 in 'Updates\BDTK.Updates.v2_1_1_7.pas',
  BDTK.Updates.v0_0_0_6 in 'Updates\BDTK.Updates.v0_0_0_6.pas',
  BDTK.Updates.v0_0_0_8 in 'Updates\BDTK.Updates.v0_0_0_8.pas',
  BDTK.Updates.v0_0_0_9 in 'Updates\BDTK.Updates.v0_0_0_9.pas',
  BDTK.Updates.v0_0_1_2 in 'Updates\BDTK.Updates.v0_0_1_2.pas',
  BDTK.Updates.v0_0_1_7 in 'Updates\BDTK.Updates.v0_0_1_7.pas',
  BDTK.Updates.v0_0_2_2 in 'Updates\BDTK.Updates.v0_0_2_2.pas',
  BDTK.Updates.v0_0_2_3 in 'Updates\BDTK.Updates.v0_0_2_3.pas',
  BDTK.Updates.v0_0_2_5 in 'Updates\BDTK.Updates.v0_0_2_5.pas',
  BDTK.Updates.v0_0_2_7 in 'Updates\BDTK.Updates.v0_0_2_7.pas',
  BDTK.Updates.v0_0_2_19 in 'Updates\BDTK.Updates.v0_0_2_19.pas',
  BDTK.Updates.v0_0_2_23 in 'Updates\BDTK.Updates.v0_0_2_23.pas',
  BDTK.Updates.v0_0_3_01 in 'Updates\BDTK.Updates.v0_0_3_01.pas',
  BDTK.Updates.v0_0_3_02 in 'Updates\BDTK.Updates.v0_0_3_02.pas',
  BDTK.Updates.v0_0_3_07 in 'Updates\BDTK.Updates.v0_0_3_07.pas',
  BDTK.Updates.v0_0_3_14 in 'Updates\BDTK.Updates.v0_0_3_14.pas',
  BDTK.Updates.v0_0_3_16 in 'Updates\BDTK.Updates.v0_0_3_16.pas',
  BDTK.Updates.v0_0_3_19 in 'Updates\BDTK.Updates.v0_0_3_19.pas',
  BDTK.Updates.v0_0_3_21 in 'Updates\BDTK.Updates.v0_0_3_21.pas',
  BDTK.Updates.v0_0_3_22 in 'Updates\BDTK.Updates.v0_0_3_22.pas',
  BDTK.Updates.v0_0_3_23 in 'Updates\BDTK.Updates.v0_0_3_23.pas',
  BDTK.Updates.v0_0_3_24 in 'Updates\BDTK.Updates.v0_0_3_24.pas',
  BDTK.Updates.v0_0_3_25 in 'Updates\BDTK.Updates.v0_0_3_25.pas',
  BDTK.Updates.v0_0_3_27 in 'Updates\BDTK.Updates.v0_0_3_27.pas',
  BDTK.Updates.v1_0_0_0 in 'Updates\BDTK.Updates.v1_0_0_0.pas',
  BDTK.Updates.v1_0_0_2 in 'Updates\BDTK.Updates.v1_0_0_2.pas',
  BDTK.Updates.v1_0_0_3 in 'Updates\BDTK.Updates.v1_0_0_3.pas',
  BDTK.Updates.v1_1_0_0 in 'Updates\BDTK.Updates.v1_1_0_0.pas',
  BDTK.Updates.v1_2_0_0 in 'Updates\BDTK.Updates.v1_2_0_0.pas',
  BDTK.Updates.v1_2_0_8 in 'Updates\BDTK.Updates.v1_2_0_8.pas',
  BDTK.Updates.v1_2_1_0 in 'Updates\BDTK.Updates.v1_2_1_0.pas',
  BDTK.Updates.v1_2_2_0 in 'Updates\BDTK.Updates.v1_2_2_0.pas',
  BDTK.Updates.v1_2_3_3 in 'Updates\BDTK.Updates.v1_2_3_3.pas',
  BDTK.Updates.v1_2_3_14 in 'Updates\BDTK.Updates.v1_2_3_14.pas',
  BDTK.Updates.v1_2_3_20 in 'Updates\BDTK.Updates.v1_2_3_20.pas',
  BDTK.Updates.v1_2_3_22 in 'Updates\BDTK.Updates.v1_2_3_22.pas',
  BDTK.Updates.v1_2_3_25 in 'Updates\BDTK.Updates.v1_2_3_25.pas',
  BDTK.Updates.v1_2_3_26 in 'Updates\BDTK.Updates.v1_2_3_26.pas',
  BDTK.Updates.v2_0_0_5 in 'Updates\BDTK.Updates.v2_0_0_5.pas',
  BDTK.Updates.v2_0_1_0 in 'Updates\BDTK.Updates.v2_0_1_0.pas',
  BDTK.Updates.v2_1_0_0 in 'Updates\BDTK.Updates.v2_1_0_0.pas',
  BDTK.Updates.v2_1_0_16 in 'Updates\BDTK.Updates.v2_1_0_16.pas',
  BDTK.Updates.v2_1_0_22 in 'Updates\BDTK.Updates.v2_1_0_22.pas',
  BDTK.Updates.v2_1_0_72 in 'Updates\BDTK.Updates.v2_1_0_72.pas',
  BDTK.Updates.v2_1_1_2 in 'Updates\BDTK.Updates.v2_1_1_2.pas',
  UfrmFusionEditions in 'Gestion\UfrmFusionEditions.pas' {frmFusionEditions},
  BDTK.Updates.v2_1_1_4 in 'Updates\BDTK.Updates.v2_1_1_4.pas',
  BDTK.Updates.v2_1_1_8 in 'Updates\BDTK.Updates.v2_1_1_8.pas',
  UfrmGallerie in 'Consultation\UfrmGallerie.pas' {frmGallerie},
  BDTK.GUI.Controls.VirtualTree in 'GUI\Controls\BDTK.GUI.Controls.VirtualTree.pas',
  BDTK.Updates.v2_1_1_10 in 'Updates\BDTK.Updates.v2_1_1_10.pas',
  BDTK.Updates.v2_1_1_17 in 'Updates\BDTK.Updates.v2_1_1_17.pas',
  BDTK.Updates.v2_1_1_155 in 'Updates\BDTK.Updates.v2_1_1_155.pas',
  UfrmConsultationAlbum in 'Consultation\UfrmConsultationAlbum.pas' {frmConsultationAlbum},
  BDTK.Updates.v2_2_2_233 in 'Updates\BDTK.Updates.v2_2_2_233.pas',
  BDTK.Updates.v2_2_3_13 in 'Updates\BDTK.Updates.v2_2_3_13.pas',
  UfrmConsultationUnivers in 'Consultation\UfrmConsultationUnivers.pas' {frmConsultationUnivers},
  UfrmEditUnivers in 'Gestion\UfrmEditUnivers.pas' {frmEditUnivers},
  BDTK.Updates.v2_2_3_16 in 'Updates\BDTK.Updates.v2_2_3_16.pas',
  BDTK.Updates.v2_2_3_17 in 'Updates\BDTK.Updates.v2_2_3_17.pas',
  BDTK.Updates.v2_2_3_19 in 'Updates\BDTK.Updates.v2_2_3_19.pas',
  BDTK.Updates.v2_2_3_21 in 'Updates\BDTK.Updates.v2_2_3_21.pas',
  BDTK.Web.Updates.v1_0_0_3 in 'Web\Updates\BDTK.Web.Updates.v1_0_0_3.pas',
  BDTK.Updates.v2_2_3_22 in 'Updates\BDTK.Updates.v2_2_3_22.pas',
  BDTK.Updates.v2_2_3_23 in 'Updates\BDTK.Updates.v2_2_3_23.pas',
  BD.Common in '..\Commun\BD.Common.pas',
  BD.Utils.StrUtils in '..\Commun\Utils\BD.Utils.StrUtils.pas',
  BD.Strings in '..\Commun\BD.Strings.pas',
  BD.GUI.Forms in '..\Commun\GUI\Forms\BD.GUI.Forms.pas' {bdtForm},
  BD.GUI.Frames.Buttons in '..\Commun\GUI\Frames\BD.GUI.Frames.Buttons.pas' {framBoutons: TFrame},
  BD.GUI.Forms.About in '..\Commun\GUI\Forms\BD.GUI.Forms.About.pas' {frmAboutBox},
  BD.GUI.Forms.Console in '..\Commun\GUI\Forms\BD.GUI.Forms.Console.pas' {frmConsole},
  BD.GUI.Forms.Progress in '..\Commun\GUI\Forms\BD.GUI.Forms.Progress.pas' {frmProgression},
  BD.GUI.Forms.Splash in '..\Commun\GUI\Forms\BD.GUI.Forms.Splash.pas' {frmSplash},
  BD.GUI.Forms.Verbose in '..\Commun\GUI\Forms\BD.GUI.Forms.Verbose.pas' {frmVerbose},
  BD.Entities.Metadata in '..\Commun\Entities\BD.Entities.Metadata.pas',
  BD.Utils.GUIUtils in '..\Commun\Utils\BD.Utils.GUIUtils.pas',
  BD.Utils.Net in '..\Commun\Utils\BD.Utils.Net.pas',
  BD.GUI.Controls.VirtualTree in '..\Commun\GUI\Controls\BD.GUI.Controls.VirtualTree.pas',
  BDTK.Entities.Dao.Full in 'Entities\BDTK.Entities.Dao.Full.pas',
  BDTK.Entities.Dao.Lite in 'Entities\BDTK.Entities.Dao.Lite.pas',
  BDTK.Entities.Dao.Search in 'Entities\BDTK.Entities.Dao.Search.pas',
  BDTK.Entities.Dao.Stats in 'Entities\BDTK.Entities.Dao.Stats.pas',
  BDTK.Entities.Search in 'Entities\BDTK.Entities.Search.pas',
  BDTK.Entities.Stats in 'Entities\BDTK.Entities.Stats.pas',
  BD.Entities.Full in '..\Commun\Entities\BD.Entities.Full.pas',
  BD.Entities.Lite in '..\Commun\Entities\BD.Entities.Lite.pas',
  BD.Entities.Common in '..\Commun\Entities\BD.Entities.Common.pas',
  BD.Entities.Factory.Common in '..\Commun\Entities\BD.Entities.Factory.Common.pas',
  BD.Entities.Dao.Lambda in '..\Commun\Entities\BD.Entities.Dao.Lambda.pas',
  BDTK.Entities.Dao.Lambda in 'Entities\BDTK.Entities.Dao.Lambda.pas',
  BD.Utils.Net.ICS in '..\Commun\Utils\BD.Utils.Net.ICS.pas',
  BDTK.Web.Forms.Synchronize in 'Web\BDTK.Web.Forms.Synchronize.pas' {frmSynchroniser},
  BDTK.Web in 'Web\BDTK.Web.pas',
  BDTK.Updates.v2_2_3_24 in 'Updates\BDTK.Updates.v2_2_3_24.pas',
  BDTK.Updates.v2_2_3_25 in 'Updates\BDTK.Updates.v2_2_3_25.pas',
  BDTK.Updates.v2_2_3_29 in 'Updates\BDTK.Updates.v2_2_3_29.pas',
  BD.Entities.Types in '..\Commun\Entities\BD.Entities.Types.pas',
  BD.Entities.Factory.Full in '..\Commun\Entities\BD.Entities.Factory.Full.pas',
  BD.Entities.Factory.Lite in '..\Commun\Entities\BD.Entities.Factory.Lite.pas',
  BD.DB.Connection in '..\Commun\Entities\BD.DB.Connection.pas',
  BD.Entities.Dao.Common in '..\Commun\Entities\BD.Entities.Dao.Common.pas',
  BD.GUI.DataModules.Common in '..\Commun\GUI\DataModules\BD.GUI.DataModules.Common.pas' {dmCommon: TDataModule},
  BDTK.GUI.Controls.Spin in 'GUI\Controls\BDTK.GUI.Controls.Spin.pas',
  BDTK.Updates.v2_2_3_33 in 'Updates\BDTK.Updates.v2_2_3_33.pas',
  BD.Utils.IOUtils in '..\Commun\Utils\BD.Utils.IOUtils.pas',
  BD.Utils.RandomForest.Classes in '..\Commun\Utils\BD.Utils.RandomForest.Classes.pas';

begin
  Application.Title := 'BDth�que';
  Application.MainFormOnTaskbar := True;
  Application.Initialize;
  Application.Run;
end.

