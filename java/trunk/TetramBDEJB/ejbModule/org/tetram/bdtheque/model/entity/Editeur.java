package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "editeurs")
public class Editeur implements Serializable {

  /**
	 * 
	 */
  private static final long serialVersionUID = 1L;

  @GeneratedValue
  @Id
  @Column(name = "id_editeur")
  private String id;
  @NotNull
  @AttributeOverrides({
      @AttributeOverride(name = "titre", column = @Column(name = "nomediteur", nullable = false, length = 50)),
      @AttributeOverride(name = "initialeTitre", column = @Column(name = "initialenomediteur", nullable = false)) })
  private Titre nom;
  private String siteWeb;

  @OneToMany(mappedBy = "editeur", fetch = FetchType.LAZY)
  private Set<Collection> collections = new HashSet<Collection>();

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

  public String getSiteWeb() {
    return siteWeb;
  }

  public void setSiteWeb(String siteWeb) {
    this.siteWeb = siteWeb;
  }

  public Set<Collection> getCollections() {
    return collections;
  }

  public void setCollections(Set<Collection> collections) {
    this.collections = collections;
  }
}
