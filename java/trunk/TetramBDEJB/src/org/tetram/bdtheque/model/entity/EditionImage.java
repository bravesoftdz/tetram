package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Couvertures")
public class EditionImage implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue
	@Column(name = "id_couverture")
	private String id;

	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_album")
	private Album album;

	@ManyToOne(optional = true, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_edition")
	private Edition edition;

	private Integer ordre;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "categorieimage", insertable = false, updatable = false)
	private ParametreCouverture categorie;

	@Embedded
	@AttributeOverrides({
			@AttributeOverride(name = "image", column = @Column(name = "imagecouverture")),
			@AttributeOverride(name = "stockage", column = @Column(name = "stockagecouverture")),
			@AttributeOverride(name = "fichier", column = @Column(name = "fichiercouverture")) })
	private Fichier image;

	protected String getId() {
		return id;
	}

	protected void setId(String id) {
		this.id = id;
	}

	protected Album getAlbum() {
		return album;
	}

	protected void setAlbum(Album album) {
		this.album = album;
	}

	protected Edition getEdition() {
		return edition;
	}

	protected void setEdition(Edition edition) {
		this.edition = edition;
	}

	protected ParametreCouverture getCategorie() {
		return categorie;
	}

	protected void setCategorie(ParametreCouverture categorie) {
		this.categorie = categorie;
	}

	protected Fichier getImage() {
		return image;
	}

	protected void setImage(Fichier image) {
		this.image = image;
	}

	protected Integer getOrdre() {
		return ordre;
	}

	protected void setOrdre(Integer ordre) {
		this.ordre = ordre;
	}

}
