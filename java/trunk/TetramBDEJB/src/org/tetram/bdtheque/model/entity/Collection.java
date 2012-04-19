package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "collections")
public class Collection implements Serializable {

  /**
	 * 
	 */
  private static final long serialVersionUID = 1L;

  @GeneratedValue
  @Id
  @Column(name = "id_collection")
  private String id;
  @AttributeOverrides({
      @AttributeOverride(name = "titre", column = @Column(name = "nomcollection", nullable = false, length = 50)),
      @AttributeOverride(name = "initialetitre", column = @Column(name = "initialenomcollection", nullable = false)) })
  private Titre nom;
  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "id_editeur")
  private Editeur editeur;

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

  public Editeur getEditeur() {
    return editeur;
  }

  public void setEditeur(Editeur editeur) {
    this.editeur = editeur;
  }

}
