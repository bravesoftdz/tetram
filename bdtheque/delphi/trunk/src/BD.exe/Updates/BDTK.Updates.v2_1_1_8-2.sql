alter table albums 
  alter initialetitrealbum type t_initiale;
alter table collections
  alter initialenomcollection type t_initiale,
  alter nomcollection type t_ident50;
alter table editeurs
  alter initialenomediteur type t_initiale,
  alter nomediteur type t_ident50;
alter table emprunteurs
  alter initialenomemprunteur type t_initiale;
alter table parabd
    alter initialetitreparabd type t_initiale;
alter table personnes
    alter initialenompersonne type t_initiale;
alter table series
    alter initialetitreserie type t_initiale;
