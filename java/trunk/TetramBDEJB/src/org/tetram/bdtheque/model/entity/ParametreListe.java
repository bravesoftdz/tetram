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

	protected int getValeur() {
		return valeur;
	}

	protected void setValeur(int valeur) {
		this.valeur = valeur;
	}

	protected String getId() {
		return id;
	}

	protected void setId(String id) {
		this.id = id;
	}

	protected String getLibelle() {
		return libelle;
	}

	protected void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	protected int getOrdre() {
		return ordre;
	}

	protected void setOrdre(int ordre) {
		this.ordre = ordre;
	}

	protected boolean isDefaut() {
		return defaut;
	}

	protected void setDefaut(boolean defaut) {
		this.defaut = defaut;
	}

	protected int getCategorie() {
		return categorie;
	}

	protected void setCategorie(int categorie) {
		this.categorie = categorie;
	}

}
