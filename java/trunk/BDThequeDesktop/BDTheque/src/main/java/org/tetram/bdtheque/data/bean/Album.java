package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.lite.AuteurAlbumLite;
import org.tetram.bdtheque.data.bean.lite.UniversLite;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Album extends DBEntity {
    private boolean complet;
    private String titreAlbum;
    private Serie serie;
    private Integer moisParution, anneeParution;
    private Integer tome;
    private Integer tomeDebut, tomeFin;
    private boolean horsSerie;
    private boolean integrale;
    private List<AuteurAlbumLite> auteurs = new ArrayList<>();
    private List<AuteurAlbumLite> scenaristes = null;
    private List<AuteurAlbumLite> dessinateurs = null;
    private List<AuteurAlbumLite> coloristes = null;
    private String sujet;
    private String notes;
    private List<Edition> editions = new ArrayList<>();
    private Integer notation;
    private List<UniversLite> univers = new ArrayList<>();
    private List<UniversLite> universFull = new ArrayList<>();

    public boolean isComplet() {
        return complet;
    }

    public void setComplet(boolean complet) {
        this.complet = complet;
    }

    public String getTitreAlbum() {
        return titreAlbum;
    }

    public void setTitreAlbum(String titreAlbum) {
        this.titreAlbum = titreAlbum;
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

    public List<AuteurAlbumLite> getAuteurs() {
        return auteurs;
    }

    public void setAuteurs(List<AuteurAlbumLite> auteurs) {
        this.auteurs = auteurs;
    }

    private void buildListsAuteurs() {
        int countScenaristes = (scenaristes != null ? scenaristes.size() : 0);
        int countDessinateurs = (dessinateurs != null ? dessinateurs.size() : 0);
        int countColoristes = (coloristes != null ? coloristes.size() : 0);

        int countAuteurs = countScenaristes + countDessinateurs + countColoristes;

        if (scenaristes == null || dessinateurs == null || coloristes == null || auteurs.size() != countAuteurs) {
            scenaristes = new ArrayList<>();
            dessinateurs = new ArrayList<>();
            coloristes = new ArrayList<>();
            for (int i = auteurs.size() - 1; i >= 0; i--) {

            }
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

    public List<AuteurAlbumLite> getScenaristes() {
        buildListsAuteurs();
        return scenaristes;
    }

    public List<AuteurAlbumLite> getDessinateurs() {
        buildListsAuteurs();
        return dessinateurs;
    }

    public List<AuteurAlbumLite> getColoristes() {
        buildListsAuteurs();
        return coloristes;
    }

    public String getSujet() {
        return sujet;
    }

    public void setSujet(String sujet) {
        this.sujet = sujet;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public List<Edition> getEditions() {
        return editions;
    }

    public void setEditions(List<Edition> editions) {
        this.editions = editions;
    }

    public Integer getNotation() {
        return notation;
    }

    public void setNotation(Integer notation) {
        this.notation = notation == 0 ? 900 : notation;
    }

    public List<UniversLite> getUnivers() {
        return univers;
    }

    public void setUnivers(List<UniversLite> univers) {
        this.univers = univers;
    }

    public List<UniversLite> getUniversFull() {
        universFull = BeanUtils.checkAndBuildListUniversFull(universFull, univers, serie);
        return universFull;
    }

    public UUID getIdSerie() {
        return serie.getId();
    }

}
