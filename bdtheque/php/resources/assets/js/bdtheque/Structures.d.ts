declare interface BaseModel {
  id: string;
  created_at: Date;
  updated_at: Date;
}

declare interface BaseImage extends BaseModel {
  ordre: Number;
  categorie: Number;
  fichier: string;
  chemin: string;
}

declare interface Album extends BaseModel {
  titre_album: string;
  initiale_titre_album: string;
  mois_parution: Number;
  annee_parution: Number;
  tome: Number;
  tome_debut: Number;
  tome_fin: Number;
  notation: Number;
  hors_serie: Boolean;
  integrale: Boolean;
  univers: [Univers];
  sujet: string;
  notes: string;

  serie: Serie;

  scenaristes: [Personne];
  dessinateurs: [Personne];
  coloristes: [Personne];

  editions: [Edition];

  images: [ImageAlbum];

  prevision_achat: Boolean;
  valide: Boolean
}

declare interface Serie extends BaseModel {
  titre_serie: string;
  initiale_titre_serie: string;
  editeur: Editeur;
  collection: Collection;

  terminee: Boolean;
  complete: Boolean;
  suivre_manquants: Boolean;
  suivre_sorties: Boolean;
  nb_albums: Number;

  sujet: string;
  notes: string;
  site_web: string;

  vo: Boolean;
  couleur: Boolean;
  etat: Number;
  reliure: Number;
  type_edition: Number;
  orientation: Number;
  format_edition: Number;
  sens_lecture: Number;
  notation: Number;

  albums: [Album];
  scenaristes: [Personne];
  dessinateurs: [Personne];
  coloristes: [Personne];
  univers: [Univers];
  genres: [Genre];
}

declare interface Editeur extends BaseModel {
  nom_editeur: string;
  initiale_nom_editeur: string;
  site_web: string;
  collections: [Collection];
}

declare interface Personne extends BaseModel {
  nom_personne: string;
  initiale_nom_personne: string;
  biographie: string;
  site_web: string;
}

declare interface Collection extends BaseModel {
  nom_collection: string;
  initiale_nom_collection: string;
  editeur: Editeur;
}

declare interface Univers extends BaseModel {
  nom_univers: string;
  initiale_nom_univers: string;
  description: string;
  site_web: string;
  univers_parent: Univers;
  univers_racine: Univers;
  univers_branches: string;
}

declare interface Edition extends BaseModel {
  album: Album;
  editeur: Editeur;
  collection: Collection;
  vo: Boolean;
  couleur: Boolean;
  etat: Number;
  reliure: Number;
  type_edition: Number;
  orientation: Number;
  format_edition: Number;
  sens_lecture: Number;
  date_achat: Date;
  annee_edition: Number;
  prix: Number;
  dedicace: Boolean;
  gratuit: Boolean;
  offert: Boolean;
  nombre_de_pages: Number;
  isbn: string;
  numero_perso: string;
  notes: string;
  images: [ImageAlbum];
}

declare interface Genre extends BaseModel {
  genre: string;
  initiale_genre: string;
}

declare interface ImageAlbum extends BaseImage {
  album: Album;
  edition: Edition;
}

declare interface ImageParaBd extends BaseImage {
  para_bd: ParaBd;
}

declare interface ParaBd extends BaseModel {
  titre_para_bd: string;
  initiale_titre_para_bd: string;
  serie: Serie;
  scenaristes: [Personne];
  dessinateurs: [Personne];
  coloristes: [Personne];
  categorie_para_bd: Number;
  description: string;
  notes: string;

  date_achat: Date;
  prevision_achat: Boolean;
  valide: Boolean;
  annee: Number;
  prix: Number;
  dedicace: Boolean;
  numerote: Boolean;
  gratuit: Boolean;
  offert: Boolean;
  univers: [Univers];
  images: [ImageParaBd];
}