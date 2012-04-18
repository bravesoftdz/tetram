package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.DiscriminatorType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Table;

@Entity
@Table(name = "listes")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "categorie", discriminatorType = DiscriminatorType.INTEGER)
public class ParametreListe implements Serializable {

  /**
	 * 
	 */
  private static final long serialVersionUID = 1L;

  @Id
  @Column(name = "ref")
  private int valeur;
  @GeneratedValue
  @Column(name = "id_liste", nullable = false)
  private String id;
  @Column(nullable = false)
  private String libelle;
  private int ordre;
  private boolean defaut;
  @Column(insertable = false, updatable = false)
  private int categorie;

  public int getValeur() {
    return valeur;
  }

  public void setValeur(int valeur) {
    this.valeur = valeur;
  }

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getLibelle() {
    return libelle;
  }

  public void setLibelle(String libelle) {
    this.libelle = libelle;
  }

  public int getOrdre() {
    return ordre;
  }

  public void setOrdre(int ordre) {
    this.ordre = ordre;
  }

  public boolean isDefaut() {
    return defaut;
  }

  public void setDefaut(boolean defaut) {
    this.defaut = defaut;
  }

  public int getCategorie() {
    return categorie;
  }

  public void setCategorie(int categorie) {
    this.categorie = categorie;
  }

}
