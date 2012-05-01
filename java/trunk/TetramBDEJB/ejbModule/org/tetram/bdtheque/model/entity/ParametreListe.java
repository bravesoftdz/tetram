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
	private Integer valeur;
	@GeneratedValue
	@Column(name = "id_liste", nullable = false)
	private String id;
	@Column(nullable = false)
	private String libelle;
	private Integer ordre;
	private Boolean defaut;
	@Column(insertable = false, updatable = false)
	private Integer categorie;

	public Integer getCategorie() {
		return categorie;
	}

	public String getId() {
		return id;
	}

	public String getLibelle() {
		return libelle;
	}

	public Integer getOrdre() {
		return ordre;
	}

	public Integer getValeur() {
		return valeur;
	}

	public Boolean isDefaut() {
		return defaut;
	}

	public void setCategorie(Integer categorie) {
		this.categorie = categorie;
	}

	public void setDefaut(Boolean defaut) {
		this.defaut = defaut;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	public void setOrdre(Integer ordre) {
		this.ordre = ordre;
	}

	public void setValeur(Integer valeur) {
		this.valeur = valeur;
	}

}
