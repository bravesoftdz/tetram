package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.sql.Blob;

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
	@Column(name = "nompersonne", nullable = false)
	private String nom;
	@Lob
	private Blob biographie;
	private String siteWeb;

	protected String getId() {
		return id;
	}

	protected void setId(String id) {
		this.id = id;
	}

	protected String getNom() {
		return nom;
	}

	protected void setNom(String nom) {
		this.nom = nom;
	}

	protected Blob getBiographie() {
		return biographie;
	}

	protected void setBiographie(Blob biographie) {
		this.biographie = biographie;
	}

	protected String getSiteWeb() {
		return siteWeb;
	}

	protected void setSiteWeb(String siteWeb) {
		this.siteWeb = siteWeb;
	}
}
