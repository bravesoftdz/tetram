package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.sql.Blob;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;

@Entity
@Table(name = "personnes")
public class Auteur implements Serializable {

  /**
	 * 
	 */
  private static final long serialVersionUID = 1L;

  @GeneratedValue
  @Id
  @Column(name = "id_personne")
  private String id;
  @AttributeOverrides({
      @AttributeOverride(name = "titre", column = @Column(name = "nompersonne", nullable = false, length = 150)),
      @AttributeOverride(name = "initialeTitre", column = @Column(name = "initialenompersonne", nullable = false)) })
  private Titre nom;
  @Lob
  private Blob biographie;
  private String siteWeb;

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public Titre getNom() {
    return nom;
  }

  public void setNom(Titre nom) {
    this.nom = nom;
  }

  public Blob getBiographie() {
    return biographie;
  }

  public void setBiographie(Blob biographie) {
    this.biographie = biographie;
  }

  public String getSiteWeb() {
    return siteWeb;
  }

  public void setSiteWeb(String siteWeb) {
    this.siteWeb = siteWeb;
  }
}
