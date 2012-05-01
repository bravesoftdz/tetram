package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.sql.Blob;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

@Entity
@Table(name = "albums")
public class Album implements Serializable {

  /**
	 * 
	 */
  private static final long serialVersionUID = 1L;

  @GeneratedValue
  @Id
  @Column(name = "id_album")
  private String id;

  private Integer moisParution;
  private Integer anneeParution;

  @ManyToOne(optional = true, cascade = CascadeType.ALL)
  @JoinColumn(name = "id_serie", nullable = true)
  private Serie serie;

  private Integer tome;
  private Integer tomeDebut;
  private Integer tomeFin;

  private boolean horsSerie;
  private boolean integrale;
  private boolean achat;
  private int nbEditions;
  @OneToMany(mappedBy = "album", fetch = FetchType.LAZY)
  private List<Edition> editions;
  @Formula("case when nbeditions > 0 then 1 else 0 end")
  private boolean complet;

  @AttributeOverrides({
      @AttributeOverride(name = "titre", column = @Column(name = "titrealbum", nullable = true, length = 150)),
      @AttributeOverride(name = "initialeTitre", column = @Column(name = "initialetitrealbum", nullable = true)) })
  private Titre titre;
  @Lob
  @Column(name = "sujetalbum")
  private Blob resume;
  @Lob
  @Column(name = "remarquesalbum")
  private Blob commentaires;

  @OneToMany(fetch = FetchType.LAZY)
  @JoinColumn(name = "id_album", insertable = false, updatable = false)
  @Where(clause = "metier=0")
  private List<ScenaristeAlbum> scenaristes;
  @OneToMany(fetch = FetchType.LAZY)
  @JoinColumn(name = "id_album", insertable = false, updatable = false)
  @Where(clause = "metier=1")
  private List<DessinateurAlbum> dessinateurs;
  @OneToMany(fetch = FetchType.LAZY)
  @JoinColumn(name = "id_album", insertable = false, updatable = false)
  @Where(clause = "metier=2")
  private List<ColoristeAlbum> coloristes;

  @ManyToOne
  @JoinColumn(name="notation", insertable = false, updatable = false)
  @Where(clause = "categorie=9")
  private ParametreNote notation;

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
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

  public Serie getSerie() {
    return serie;
  }

  public void setSerie(Serie serie) {
    this.serie = serie;
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

  public boolean isAchat() {
    return achat;
  }

  public void setAchat(boolean achat) {
    this.achat = achat;
  }

  public int getNbEditions() {
    return nbEditions;
  }

  public void setNbEditions(int nbEditions) {
    this.nbEditions = nbEditions;
  }

  public List<Edition> getEditions() {
    return editions;
  }

  public void setEditions(List<Edition> editions) {
    this.editions = editions;
  }

  public boolean isComplet() {
    return complet;
  }

  public void setComplet(boolean complet) {
    this.complet = complet;
  }

  public Titre getTitre() {
    return titre;
  }

  public void setTitre(Titre titre) {
    this.titre = titre;
  }

  public Blob getResume() {
    return resume;
  }

  public void setResume(Blob resume) {
    this.resume = resume;
  }

  public Blob getCommentaires() {
    return commentaires;
  }

  public void setCommentaires(Blob commentaires) {
    this.commentaires = commentaires;
  }

  public List<ScenaristeAlbum> getScenaristes() {
    return scenaristes;
  }

  public void setScenaristes(List<ScenaristeAlbum> scenaristes) {
    this.scenaristes = scenaristes;
  }

  public List<DessinateurAlbum> getDessinateurs() {
    return dessinateurs;
  }

  public void setDessinateurs(List<DessinateurAlbum> dessinateurs) {
    this.dessinateurs = dessinateurs;
  }

  public List<ColoristeAlbum> getColoristes() {
    return coloristes;
  }

  public void setColoristes(List<ColoristeAlbum> coloristes) {
    this.coloristes = coloristes;
  }

  public boolean isIntegrale() {
    return integrale;
  }

  public void setIntegrale(boolean integrale) {
    this.integrale = integrale;
  }

  public ParametreNote getNotation() {
    return notation;
  }

  public void setNotation(ParametreNote notation) {
    this.notation = notation;
  }

}
