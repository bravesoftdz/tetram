package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.dao.ValeurListeDao;

import java.util.Comparator;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Album extends AbstractDBEntity {
    public static Comparator<Album> DEFAULT_COMPARATOR = new Comparator<Album>() {
        @Override
        public int compare(Album o1, Album o2) {
            if (o1 == o2) return 0;

            int comparaison;

            // horsSerie nulls first
            comparaison = BeanUtils.compare(o1.isHorsSerie(), o2.isHorsSerie());
            if (comparaison != 0) return comparaison;

            // integrale nulls first
            comparaison = BeanUtils.compare(o1.isIntegrale(), o2.isIntegrale());
            if (comparaison != 0) return comparaison;

            // tome nulls first
            comparaison = BeanUtils.compare(o1.getTome(), o2.getTome());
            if (comparaison != 0) return comparaison;

            // anneeParution nulls first
            comparaison = BeanUtils.compare(o1.getAnneeParution(), o2.getAnneeParution());
            if (comparaison != 0) return comparaison;

            // moisParution nulls first
            comparaison = BeanUtils.compare(o1.getMoisParution(), o2.getMoisParution());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private boolean complet;
    private String titreAlbum;
    private Serie serie;
    private Integer moisParution, anneeParution;
    private Integer tome;
    private Integer tomeDebut, tomeFin;
    private boolean horsSerie;
    private boolean integrale;
    private Set<AuteurAlbumLite> auteurs = new HashSet<>();
    private Set<AuteurAlbumLite> scenaristes = null;
    private Set<AuteurAlbumLite> dessinateurs = null;
    private Set<AuteurAlbumLite> coloristes = null;
    private String sujet;
    private String notes;
    private Set<Edition> editions = new HashSet<>();
    private ValeurListe notation;
    private Set<UniversLite> univers = new HashSet<>();
    private Set<UniversLite> universFull = new HashSet<>();

    public Album() {
        ValeurListeDao valeurListeDao = Database.getInstance().getApplicationContext().getBean(ValeurListeDao.class);
        notation = valeurListeDao.getDefaultNotation();
    }

    public boolean isComplet() {
        return complet;
    }

    public void setComplet(boolean complet) {
        this.complet = complet;
    }

    public String getTitreAlbum() {
        return BeanUtils.trim(titreAlbum);
    }

    public void setTitreAlbum(String titreAlbum) {
        this.titreAlbum = BeanUtils.trim(titreAlbum);
    }

    public Serie getSerie() {
        return serie;
    }

    public void setSerie(Serie serie) {
        this.serie = serie;
    }

    public Integer getMoisParution() {
        return moisParution;
    }

    public void setMoisParution(Integer moisParution) {
        this.moisParution = moisParution;
    }

    public Integer getAnneeParution() {
        return anneeParution;
    }

    public void setAnneeParution(Integer anneeParution) {
        this.anneeParution = anneeParution;
    }

    public Integer getTome() {
        return tome;
    }

    public void setTome(Integer tome) {
        this.tome = tome;
    }

    public Integer getTomeDebut() {
        return tomeDebut;
    }

    public void setTomeDebut(Integer tomeDebut) {
        this.tomeDebut = tomeDebut;
    }

    public Integer getTomeFin() {
        return tomeFin;
    }

    public void setTomeFin(Integer tomeFin) {
        this.tomeFin = tomeFin;
    }

    public boolean isHorsSerie() {
        return horsSerie;
    }

    public void setHorsSerie(boolean horsSerie) {
        this.horsSerie = horsSerie;
    }

    public boolean isIntegrale() {
        return integrale;
    }

    public void setIntegrale(boolean integrale) {
        this.integrale = integrale;
    }

    public Set<AuteurAlbumLite> getAuteurs() {
        return auteurs;
    }

    public void setAuteurs(Set<AuteurAlbumLite> auteurs) {
        this.auteurs = auteurs;
    }

    private void buildListsAuteurs() {
        int countScenaristes = (scenaristes != null ? scenaristes.size() : 0);
        int countDessinateurs = (dessinateurs != null ? dessinateurs.size() : 0);
        int countColoristes = (coloristes != null ? coloristes.size() : 0);

        int countAuteurs = countScenaristes + countDessinateurs + countColoristes;

        if (scenaristes == null || dessinateurs == null || coloristes == null || auteurs.size() != countAuteurs) {
            scenaristes = new HashSet<>();
            dessinateurs = new HashSet<>();
            coloristes = new HashSet<>();
            for (AuteurAlbumLite a : auteurs) {
                switch (a.getMetier()) {
                    case SCENARISTE:
                        scenaristes.add(a);
                        break;
                    case DESSINATEUR:
                        dessinateurs.add(a);
                        break;
                    case COLORISTE:
                        coloristes.add(a);
                        break;
                }
            }
        }
    }

    public Set<AuteurAlbumLite> getScenaristes() {
        buildListsAuteurs();
        return scenaristes;
    }

    private void addAuteur(PersonneLite personne, Set<AuteurAlbumLite> listAuteurs, MetierAuteur metier) {
        for (AuteurAlbumLite auteur : listAuteurs)
            if (auteur.getPersonne() == personne) return;
        AuteurAlbumLite auteur = new AuteurAlbumLite();
        auteur.setPersonne(personne);
        auteur.setMetier(metier);
        listAuteurs.add(auteur);
        auteurs.add(auteur);
    }

    public void addScenariste(PersonneLite personne) {
        addAuteur(personne, getScenaristes(), MetierAuteur.SCENARISTE);
    }

    public void addDessinateur(PersonneLite personne) {
        addAuteur(personne, getDessinateurs(), MetierAuteur.DESSINATEUR);
    }

    public void addColoriste(PersonneLite personne) {
        addAuteur(personne, getColoristes(), MetierAuteur.COLORISTE);
    }

    private void removeAuteur(PersonneLite personne, Set<AuteurAlbumLite> listAuteurs) {
        for (AuteurAlbumLite auteur : listAuteurs)
            if (auteur.getPersonne() == personne) {
                listAuteurs.remove(auteur);
                auteurs.remove(auteur);
                return;
            }
    }

    public void removeScenariste(PersonneLite personne) {
        removeAuteur(personne, getScenaristes());
    }

    public void removeDessinateur(PersonneLite personne) {
        removeAuteur(personne, getDessinateurs());
    }

    public void removeColoriste(PersonneLite personne) {
        removeAuteur(personne, getColoristes());
    }

    public Set<AuteurAlbumLite> getDessinateurs() {
        buildListsAuteurs();
        return dessinateurs;
    }

    public Set<AuteurAlbumLite> getColoristes() {
        buildListsAuteurs();
        return coloristes;
    }

    public String getSujet() {
        return BeanUtils.trim(sujet);
    }

    public void setSujet(String sujet) {
        this.sujet = BeanUtils.trim(sujet);
    }

    public String getNotes() {
        return BeanUtils.trim(notes);
    }

    public void setNotes(String notes) {
        this.notes = BeanUtils.trim(notes);
    }

    public Set<Edition> getEditions() {
        return editions;
    }

    public void setEditions(Set<Edition> editions) {
        this.editions = editions;
    }

    public boolean addEdition(Edition edition) {
        return getEditions().add(edition);
    }

    public boolean removeEdition(Edition edition) {
        return getEditions().remove(edition);
    }

    public ValeurListe getNotation() {
        return notation;
    }

    public void setNotation(ValeurListe notation) {
        this.notation = notation == null || notation.getValeur() == 0 ? Database.getInstance().getApplicationContext().getBean(ValeurListeDao.class).getDefaultNotation() : notation;
    }

    public Set<UniversLite> getUnivers() {
        return univers;
    }

    public void setUnivers(Set<UniversLite> univers) {
        this.univers = univers;
    }

    public Set<UniversLite> getUniversFull() {
        universFull = BeanUtils.checkAndBuildListUniversFull(universFull, getUnivers(), serie);
        return universFull;
    }

    @SuppressWarnings("SimplifiableIfStatement")
    public boolean addUnivers(UniversLite universLite) {
        if (!getUnivers().contains(universLite) && !getUniversFull().contains(universLite)) {
            universFull.add(universLite);
            return univers.add(universLite);
        }
        return false;
    }

    public boolean removeUnivers(UniversLite universLite) {
        if (getUnivers().remove(universLite)) {
            getUniversFull().remove(universLite);
            return true;
        } else
            return false;
    }

    public UUID getIdSerie() {
        return getSerie().getId();
    }

}
