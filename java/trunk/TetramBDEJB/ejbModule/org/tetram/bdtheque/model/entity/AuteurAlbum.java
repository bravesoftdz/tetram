package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.DiscriminatorType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "metier", discriminatorType = DiscriminatorType.STRING)
@Table(name = "auteurs")
public class AuteurAlbum implements Serializable {

  /**
	 * 
	 */
  private static final long serialVersionUID = 1L;

  @GeneratedValue
  @Id
  @Column(name = "id_auteur")
  private String id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "id_personne")
  private Auteur auteur;
  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "id_album")
  private Album album;

  @Enumerated(EnumType.ORDINAL)
  @Column(nullable = false, insertable = false, updatable = false)
  private MetierAuteur metier;

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public Auteur getAuteur() {
    return auteur;
  }

  public void setAuteur(Auteur auteur) {
    this.auteur = auteur;
  }

  public Album getAlbum() {
    return album;
  }

  public void setAlbum(Album album) {
    this.album = album;
  }

  public MetierAuteur getMetier() {
    return metier;
  }

  public void setMetier(MetierAuteur metier) {
    this.metier = metier;
  }

}
