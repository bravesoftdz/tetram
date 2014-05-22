alter table albums
  alter titrealbum to old_titrealbum,
  alter sujetalbum to old_sujealbum,
  alter remarquesalbum to old_remarquesalbum,
  alter soundextitrealbum to old_soundextitrealbum;

alter table albums
  add titrealbum t_titre,
  add sujetalbum t_description,
  add remarquesalbum t_description,
  add soundextitrealbum varchar(30) character set iso8859_1 collate fr_fr_ci_ai;

update albums set
  titrealbum = old_titrealbum,
  sujetalbum = old_sujealbum,
  remarquesalbum = old_remarquesalbum,
  soundextitrealbum = old_soundextitrealbum;

alter table albums
  drop old_titrealbum,
  drop old_sujealbum,
  drop old_remarquesalbum,
  drop old_soundextitrealbum,
  drop uppertitrealbum,
  drop uppersujetalbum,
  drop upperremarquesalbum;


alter table collections
  alter nomcollection to old_nomcollection;

alter table collections
  add nomcollection varchar(50) character set iso8859_1 collate fr_fr_ci_ai;

update collections set
  nomcollection = old_nomcollection;

alter table collections
  drop old_nomcollection,
  drop uppernomcollection;


alter table conversions
  alter monnaie1 to old_monnaie1,
  alter monnaie2 to old_monnaie2;

alter table conversions
  add monnaie1 varchar(5) character set iso8859_1 collate fr_fr_ci_ai,
  add monnaie2 varchar(5) character set iso8859_1 collate fr_fr_ci_ai;

update conversions set
  monnaie1 = old_monnaie1,
  monnaie2 = old_monnaie2;

alter table conversions
  drop old_monnaie1,
  drop old_monnaie2;


alter table criteres
  alter critere to old_critere;

alter table criteres
  add critere varchar(20) character set iso8859_1 collate fr_fr_ci_ai;

update criteres set
  critere = old_critere;

alter table criteres
  drop old_critere;


alter table editeurs
  alter nomediteur to old_nomediteur;

alter table editeurs
  add nomediteur varchar(50) character set iso8859_1 collate fr_fr_ci_ai;

update editeurs set
  nomediteur = old_nomediteur;

alter table editeurs
  drop old_nomediteur,
  drop uppernomediteur;


alter table editions
  alter notes to old_notes;

alter table editions
  add notes t_description;

update editions set
  notes = old_notes;

alter table editions
  drop old_notes;


alter table emprunteurs
  alter nomemprunteur to old_nomemprunteur,
  alter adresseemprunteur to old_adresseemprunteur;

alter table emprunteurs
  add nomemprunteur t_nom,
  add adresseemprunteur t_description;

update emprunteurs set
  nomemprunteur = old_nomemprunteur,
  adresseemprunteur = old_adresseemprunteur;

alter table emprunteurs
  drop old_nomemprunteur,
  drop uppernomemprunteur,
  drop old_adresseemprunteur;


alter table genres
  alter genre to old_genre;

alter table genres
  add genre varchar(30) character set iso8859_1 collate fr_fr_ci_ai;

update genres set
  genre = old_genre;

alter table genres
  drop old_genre,
  drop uppergenre;


alter table listes
  alter libelle to old_libelle;

alter table listes
  add libelle varchar(50) character set iso8859_1 collate fr_fr_ci_ai;

update listes set
  libelle = old_libelle;

alter table listes
  drop old_libelle;


alter table parabd
  alter titreparabd to old_titreparabd,
  alter description to old_description,
  alter soundextitreparabd to old_soundextitreparabd;

alter table parabd
  add titreparabd t_titre,
  add description t_description,
  add soundextitreparabd varchar(30) character set iso8859_1 collate fr_fr_ci_ai;

update parabd set
  titreparabd = old_titreparabd,
  description = old_description,
  soundextitreparabd = old_soundextitreparabd;

alter table parabd
  drop old_titreparabd,
  drop old_description,
  drop old_soundextitreparabd,
  drop uppertitreparabd,
  drop upperdescription;


alter table personnes
  alter nompersonne to old_nompersonne,
  alter biographie to old_biographie;

alter table personnes
  add nompersonne t_titre,
  add biographie t_description;

update personnes set
  nompersonne = old_nompersonne,
  biographie = old_biographie;

alter table personnes
  drop old_nompersonne,
  drop old_biographie,
  drop uppernompersonne;


alter table series
  alter titreserie to old_titreserie,
  alter sujetserie to old_sujeserie,
  alter remarquesserie to old_remarquesserie,
  alter soundextitreserie to old_soundextitreserie;

alter table series
  add titreserie t_titre,
  add sujetserie t_description,
  add remarquesserie t_description,
  add soundextitreserie varchar(30) character set iso8859_1 collate fr_fr_ci_ai;

update series set
  titreserie = old_titreserie,
  sujetserie = old_sujeserie,
  remarquesserie = old_remarquesserie,
  soundextitreserie = old_soundextitreserie;

alter table series
  drop old_titreserie,
  drop old_sujeserie,
  drop old_remarquesserie,
  drop old_soundextitreserie,
  drop uppertitreserie,
  drop uppersujetserie,
  drop upperremarquesserie;
