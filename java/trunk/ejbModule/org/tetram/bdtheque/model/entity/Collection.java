package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

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
	@Column(name = "nomcollection", nullable = false)
	private String nom;
	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_editeur")
	private Editeur editeur;

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

	protected Editeur getEditeur() {
		return editeur;
	}

	protected void setEditeur(Editeur editeur) {
		this.editeur = editeur;
	}

}
