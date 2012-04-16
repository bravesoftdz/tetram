package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

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
	@Column(name = "nomediteur", nullable = false)
	private String nom;
	private String siteWeb;

	@OneToMany(mappedBy = "editeur", fetch = FetchType.LAZY)
	private Set<Collection> collections = new HashSet<Collection>();

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

	protected String getSiteWeb() {
		return siteWeb;
	}

	protected void setSiteWeb(String siteWeb) {
		this.siteWeb = siteWeb;
	}

	protected Set<Collection> getCollections() {
		return collections;
	}

	protected void setCollections(Set<Collection> collections) {
		this.collections = collections;
	}
}
