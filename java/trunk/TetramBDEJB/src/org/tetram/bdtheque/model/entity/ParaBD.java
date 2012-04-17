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

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Serie getSerie() {
		return serie;
	}

	public void setSerie(Serie serie) {
		this.serie = serie;
	}

	public String getTitre() {
		return titre;
	}

	public void setTitre(String titre) {
		this.titre = titre;
	}

	public Blob getCommentaire() {
		return commentaire;
	}

	public void setCommentaire(Blob commentaire) {
		this.commentaire = commentaire;
	}

	public boolean isAchat() {
		return achat;
	}

	public void setAchat(boolean achat) {
		this.achat = achat;
	}

	public boolean isComplet() {
		return complet;
	}

	public void setComplet(boolean complet) {
		this.complet = complet;
	}

	public boolean isDedicace() {
		return dedicace;
	}

	public void setDedicace(boolean dedicace) {
		this.dedicace = dedicace;
	}

	public boolean isNumerote() {
		return numerote;
	}

	public void setNumerote(boolean numerote) {
		this.numerote = numerote;
	}

	public Integer getAnnee() {
		return annee;
	}

	public void setAnnee(Integer annee) {
		this.annee = annee;
	}

	public BigDecimal getPrix() {
		return prix;
	}

	public void setPrix(BigDecimal prix) {
		this.prix = prix;
	}

	public boolean isPrete() {
		return prete;
	}

	public void setPrete(boolean prete) {
		this.prete = prete;
	}

	public boolean isStock() {
		return stock;
	}

	public void setStock(boolean stock) {
		this.stock = stock;
	}

	public Date getDateAchat() {
		return dateAchat;
	}

	public void setDateAchat(Date dateAchat) {
		this.dateAchat = dateAchat;
	}

	public boolean isGratuit() {
		return gratuit;
	}

	public void setGratuit(boolean gratuit) {
		this.gratuit = gratuit;
	}

	public boolean isOffert() {
		return offert;
	}

	public void setOffert(boolean offert) {
		this.offert = offert;
	}

	public List<Auteur> getAuteurs() {
		return auteurs;
	}

	public void setAuteurs(List<Auteur> auteurs) {
		this.auteurs = auteurs;
	}

	public Cote getCote() {
		return cote;
	}

	public void setCote(Cote cote) {
		this.cote = cote;
	}

	public List<CoteParaBD> getCotes() {
		return cotes;
	}

	public void setCotes(List<CoteParaBD> cotes) {
		this.cotes = cotes;
	}

	public void setImage(Fichier image) {
		this.image = image;
	}

	public Fichier getImage() {
		return image;
	}
}
