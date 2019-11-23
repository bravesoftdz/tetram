﻿unit BDTK.Web.Browser.Utils;

interface

uses
  Winapi.Messages, uCEFConstants;

const
  // les threads de CEF empêchent d'utiliser Synchronize
  // et puisque certains events CEF ne sont pas déclenchés dans le thread principal... il ne reste que la solution des messages
  BDTKBROWSER = WM_APP + $100;
  BDTKBROWSER_CLOSE = BDTKBROWSER + $00;
  BDTKBROWSER_MODALRESULT = BDTKBROWSER + $01;
  BDTKBROWSER_DESTROYWNDPARENT = BDTKBROWSER + $02;
  BDTKBROWSER_DESTROYTAB = BDTKBROWSER + $03;
  BDTKBROWSER_URLREQUEST_SUCCESS = BDTKBROWSER + $04;
  BDTKBROWSER_URLREQUEST_ERROR = BDTKBROWSER + $05;

  BDTKBROWSER_RUN_ACTION = WM_APP + $03;
  BDTKBROWSER_SHOWDEVTOOLS = WM_APP + $04;
  BDTKBROWSER_HIDEDEVTOOLS = WM_APP + $05;

  BDTKBROWSER_CONTEXTMENU_TOOLS = MENU_ID_USER_FIRST;
  BDTKBROWSER_CONTEXTMENU_IMPORT = MENU_ID_USER_FIRST + $100;

  BDTKBROWSER_CONTEXTMENU_TOGGLEDEVTOOLS = BDTKBROWSER_CONTEXTMENU_TOOLS + $01;
  BDTKBROWSER_CONTEXTMENU_TOGGLEAUDIO = BDTKBROWSER_CONTEXTMENU_TOOLS + $02;
  BDTKBROWSER_CONTEXTMENU_LINK_TO_NEW_TAB = BDTKBROWSER_CONTEXTMENU_TOOLS + $03;
  BDTKBROWSER_CONTEXTMENU_COPY_LINK = BDTKBROWSER_CONTEXTMENU_TOOLS + $04;
  BDTKBROWSER_CONTEXTMENU_EMPTY_CACHE_AND_RELOAD = BDTKBROWSER_CONTEXTMENU_TOOLS + $05;

  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM = BDTKBROWSER_CONTEXTMENU_IMPORT + $000;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TITRE = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $01;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $02;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution_Mois = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $03;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution_Annee = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $04;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Parution_Date = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $05;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Tome = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $06;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TomeDebut = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $07;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_TomeFin = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $08;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_HorsSerie = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $09;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Integrale = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $0A;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Auteur = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $0B;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Scenaristes = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $0C;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Dessinateurs = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $0D;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Coloristes = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $0E;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Sujet = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $0F;
  BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM_Notes = BDTKBROWSER_CONTEXTMENU_IMPORT_ALBUM + $10;

  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE = BDTKBROWSER_CONTEXTMENU_IMPORT + $100;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_TITRE = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $01;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_SiteWeb = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $02;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Univers = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $03;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_NbAlbums = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $04;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Terminee = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $05;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Genres = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $06;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Auteurs = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $07;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Scenaristes = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $08;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Dessinateurs = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $09;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Coloristes = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $0A;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Sujet = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $0B;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Notes = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $0C;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Editeur_NomEditeur = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $0D;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Editeur_SiteWeb = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $0E;
  BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE_Collection_NomCollection = BDTKBROWSER_CONTEXTMENU_IMPORT_SERIE + $0F;

  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION = BDTKBROWSER_CONTEXTMENU_IMPORT + $200;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Editeur_NomEditeur = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $01;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Editeur_SiteWeb = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $02;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Collection_NomCollection = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $03;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_AnneeEdition = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $04;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Prix = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $05;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Gratuit = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $06;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_ISBN = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $07;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Etat = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $08;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_TypeEdition = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $09;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Reliure = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $0A;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Orientation = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $0B;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_SensLecture = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $0C;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_FormatEdition = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $0D;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_AnneeCote = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $0E;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_PrixCote = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $0F;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Couleur = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $10;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_VO = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $11;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_NombreDePages = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $12;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Image = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $13;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Image_First = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $14;
  BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION_Image_Last = BDTKBROWSER_CONTEXTMENU_IMPORT_EDITION + $20;

implementation

end.
