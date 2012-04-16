package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Blob;
import java.util.Date;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.Lob;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderColumn;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
public class ParaBD implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@GeneratedValue
	@Id
	@Column(name = "id_parabd")
	private String id;

	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_serie")
	private Serie serie;

	@Column(name = "titreparabd")
	private String titre;
	@Lob
	@Column(name = "description")
	private Blob commentaire;
	private boolean achat;
	private boolean complet;
	private boolean dedicace;
	private boolean numerote;
	private Integer annee;
	private BigDecimal prix;
	@Embedded
	private Cote cote;
	private boolean prete;
	private boolean stock;
	@Temporal(TemporalType.DATE)
	private Date dateAchat;
	private boolean gratuit;
	private boolean offert;

	@AttributeOverrides({
			@AttributeOverride(name = "image", column = @Column(name = "imageparabd")),
			@AttributeOverride(name = "stockage", column = @Column(name = "stockageparabd")),
			@AttributeOverride(name = "fichier", column = @Column(name = "fichierparabd")) })
	private Fichier image;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "auteurs_parabd", joinColumns = @JoinColumn(name = "id_parabd"), inverseJoinColumns = @JoinColumn(name = "id_personne"))
	private List<Auteur> auteurs;

	@OneToMany(mappedBy = "paraBD", fetch = FetchType.LAZY)
	@OrderColumn(name = "anneecote")
	private List<CoteParaBD> cotes;

	protected String getId() {
		return id;
	}

	protected void setId(String id) {
		this.id = id;
	}

	protected Serie getSerie() {
		return serie;
	}

	protected void setSerie(Serie serie) {
		this.serie = serie;
	}

	protected String getTitre() {
		return titre;
	}

	protected void setTitre(String titre) {
		this.titre = titre;
	}

	protected Blob getCommentaire() {
		return commentaire;
	}

	protected void setCommentaire(Blob commentaire) {
		this.commentaire = commentaire;
	}

	protected boolean isAchat() {
		return achat;
	}

	protected void setAchat(boolean achat) {
		this.achat = achat;
	}

	protected boolean isComplet() {
		return complet;
	}

	protected void setComplet(boolean complet) {
		this.complet = complet;
	}

	protected boolean isDedicace() {
		return dedicace;
	}

	protected void setDedicace(boolean dedicace) {
		this.dedicace = dedicace;
	}

	protected boolean isNumerote() {
		return numerote;
	}

	protected void setNumerote(boolean numerote) {
		this.numerote = numerote;
	}

	protected Integer getAnnee() {
		return annee;
	}

	protected void setAnnee(Integer annee) {
		this.annee = annee;
	}

	protected BigDecimal getPrix() {
		return prix;
	}

	protected void setPrix(BigDecimal prix) {
		this.prix = prix;
	}

	protected boolean isPrete() {
		return prete;
	}

	protected void setPrete(boolean prete) {
		this.prete = prete;
	}

	protected boolean isStock() {
		return stock;
	}

	protected void setStock(boolean stock) {
		this.stock = stock;
	}

	protected Date getDateAchat() {
		return dateAchat;
	}

	protected void setDateAchat(Date dateAchat) {
		this.dateAchat = dateAchat;
	}

	protected boolean isGratuit() {
		return gratuit;
	}

	protected void setGratuit(boolean gratuit) {
		this.gratuit = gratuit;
	}

	protected boolean isOffert() {
		return offert;
	}

	protected void setOffert(boolean offert) {
		this.offert = offert;
	}

	protected List<Auteur> getAuteurs() {
		return auteurs;
	}

	protected void setAuteurs(List<Auteur> auteurs) {
		this.auteurs = auteurs;
	}

	protected Cote getCote() {
		return cote;
	}

	protected void setCote(Cote cote) {
		this.cote = cote;
	}

	protected List<CoteParaBD> getCotes() {
		return cotes;
	}

	protected void setCotes(List<CoteParaBD> cotes) {
		this.cotes = cotes;
	}

	protected void setImage(Fichier image) {
		this.image = image;
	}

	protected Fichier getImage() {
		return image;
	}
}
