package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Blob;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderColumn;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "editions")
public class Edition implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@GeneratedValue
	@Id
	@Column(name = "id_edition")
	private String id;

	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_album")
	private Album album;

	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_editeur")
	private Editeur editeur;
	@ManyToOne(optional = true, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_collection")
	private Collection collection;

	private Integer anneeEdition;
	private BigDecimal prix;
	private Boolean vo;
	private Boolean couleur;
	private String isbn;
	private Boolean prete;
	private Boolean stock;
	private Boolean dedicace;
	@Temporal(TemporalType.DATE)
	private Date dateAchat;
	private Boolean gratuit;
	private Boolean offert;
	@Column(name = "nombredepages")
	private Integer nbPages;

	@Embedded
	private ConfigurationEdition etat;

	@Embedded
	private Cote cote;
	private String numeroPerso;
	@Lob
	@Column(name = "notes")
	private Blob commentaires;

	@OneToMany(mappedBy = "edition", fetch = FetchType.LAZY)
	@OrderColumn(name="anneecote")
	private List<CoteEdition> cotes;

	@OneToMany(mappedBy = "edition", fetch = FetchType.LAZY)
	@OrderColumn(name = "ordre")
	private List<EditionImage> images;

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

	protected Editeur getEditeur() {
		return editeur;
	}

	protected void setEditeur(Editeur editeur) {
		this.editeur = editeur;
	}

	protected Collection getCollection() {
		return collection;
	}

	protected void setCollection(Collection collection) {
		this.collection = collection;
	}

	protected Integer getAnneeEdition() {
		return anneeEdition;
	}

	protected void setAnneeEdition(Integer anneeEdition) {
		this.anneeEdition = anneeEdition;
	}

	protected BigDecimal getPrix() {
		return prix;
	}

	protected void setPrix(BigDecimal prix) {
		this.prix = prix;
	}

	protected Boolean getVo() {
		return vo;
	}

	protected void setVo(Boolean vo) {
		this.vo = vo;
	}

	protected Boolean getCouleur() {
		return couleur;
	}

	protected void setCouleur(Boolean couleur) {
		this.couleur = couleur;
	}

	protected String getIsbn() {
		return isbn;
	}

	protected void setIsbn(String isbn) {
		this.isbn = isbn;
	}

	protected Boolean getPrete() {
		return prete;
	}

	protected void setPrete(Boolean prete) {
		this.prete = prete;
	}

	protected Boolean getStock() {
		return stock;
	}

	protected void setStock(Boolean stock) {
		this.stock = stock;
	}

	protected Boolean getDedicace() {
		return dedicace;
	}

	protected void setDedicace(Boolean dedicace) {
		this.dedicace = dedicace;
	}

	protected Date getDateAchat() {
		return dateAchat;
	}

	protected void setDateAchat(Date dateAchat) {
		this.dateAchat = dateAchat;
	}

	protected Boolean getGratuit() {
		return gratuit;
	}

	protected void setGratuit(Boolean gratuit) {
		this.gratuit = gratuit;
	}

	protected Boolean getOffert() {
		return offert;
	}

	protected void setOffert(Boolean offert) {
		this.offert = offert;
	}

	protected Integer getNbPages() {
		return nbPages;
	}

	protected void setNbPages(Integer nbPages) {
		this.nbPages = nbPages;
	}

	protected ConfigurationEdition getEtat() {
		return etat;
	}

	protected void setEtat(ConfigurationEdition etat) {
		this.etat = etat;
	}

	protected Cote getCote() {
		return cote;
	}

	protected void setCote(Cote cote) {
		this.cote = cote;
	}

	protected String getNumeroPerso() {
		return numeroPerso;
	}

	protected void setNumeroPerso(String numeroPerso) {
		this.numeroPerso = numeroPerso;
	}

	protected Blob getCommentaires() {
		return commentaires;
	}

	protected void setCommentaires(Blob commentaires) {
		this.commentaires = commentaires;
	}

	protected List<CoteEdition> getCotes() {
		return cotes;
	}

	protected void setCotes(List<CoteEdition> cotes) {
		this.cotes = cotes;
	}

	protected List<EditionImage> getImages() {
		return images;
	}

	protected void setImages(List<EditionImage> images) {
		this.images = images;
	}

}
