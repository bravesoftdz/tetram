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
@Table(name = "auteurs_parabd")
public class AuteurParaBD implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@GeneratedValue
	@Id
	@Column(name = "id_auteur_parabd")
	private String id;

	@ManyToOne(optional = false,fetch=FetchType.LAZY)
	@JoinColumn(name="id_personne")
	private Auteur auteur;

	protected String getId() {
		return id;
	}

	protected void setId(String id) {
		this.id = id;
	}

	protected Auteur getAuteur() {
		return auteur;
	}

	protected void setAuteur(Auteur auteur) {
		this.auteur = auteur;
	}
}
