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
	@Column(columnDefinition = "numeric(15,2)")
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
	@OrderColumn(name = "anneecote")
	private List<CoteEdition> cotes;

	@OneToMany(mappedBy = "edition", fetch = FetchType.LAZY)
	@OrderColumn(name = "ordre")
	private List<EditionImage> images;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Album getAlbum() {
		return album;
	}

	public void setAlbum(Album album) {
		this.album = album;
	}

	public Editeur getEditeur() {
		return editeur;
	}

	public void setEditeur(Editeur editeur) {
		this.editeur = editeur;
	}

	public Collection getCollection() {
		return collection;
	}

	public void setCollection(Collection collection) {
		this.collection = collection;
	}

	public Integer getAnneeEdition() {
		return anneeEdition;
	}

	public void setAnneeEdition(Integer anneeEdition) {
		this.anneeEdition = anneeEdition;
	}

	public BigDecimal getPrix() {
		return prix;
	}

	public void setPrix(BigDecimal prix) {
		this.prix = prix;
	}

	public Boolean getVo() {
		return vo;
	}

	public void setVo(Boolean vo) {
		this.vo = vo;
	}

	public Boolean getCouleur() {
		return couleur;
	}

	public void setCouleur(Boolean couleur) {
		this.couleur = couleur;
	}

	public String getIsbn() {
		return isbn;
	}

	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}

	public Boolean getPrete() {
		return prete;
	}

	public void setPrete(Boolean prete) {
		this.prete = prete;
	}

	public Boolean getStock() {
		return stock;
	}

	public void setStock(Boolean stock) {
		this.stock = stock;
	}

	public Boolean getDedicace() {
		return dedicace;
	}

	public void setDedicace(Boolean dedicace) {
		this.dedicace = dedicace;
	}

	public Date getDateAchat() {
		return dateAchat;
	}

	public void setDateAchat(Date dateAchat) {
		this.dateAchat = dateAchat;
	}

	public Boolean getGratuit() {
		return gratuit;
	}

	public void setGratuit(Boolean gratuit) {
		this.gratuit = gratuit;
	}

	public Boolean getOffert() {
		return offert;
	}

	public void setOffert(Boolean offert) {
		this.offert = offert;
	}

	public Integer getNbPages() {
		return nbPages;
	}

	public void setNbPages(Integer nbPages) {
		this.nbPages = nbPages;
	}

	public ConfigurationEdition getEtat() {
		return etat;
	}

	public void setEtat(ConfigurationEdition etat) {
		this.etat = etat;
	}

	public Cote getCote() {
		return cote;
	}

	public void setCote(Cote cote) {
		this.cote = cote;
	}

	public String getNumeroPerso() {
		return numeroPerso;
	}

	public void setNumeroPerso(String numeroPerso) {
		this.numeroPerso = numeroPerso;
	}

	public Blob getCommentaires() {
		return commentaires;
	}

	public void setCommentaires(Blob commentaires) {
		this.commentaires = commentaires;
	}

	public List<CoteEdition> getCotes() {
		return cotes;
	}

	public void setCotes(List<CoteEdition> cotes) {
		this.cotes = cotes;
	}

	public List<EditionImage> getImages() {
		return images;
	}

	public void setImages(List<EditionImage> images) {
		this.images = images;
	}

}
