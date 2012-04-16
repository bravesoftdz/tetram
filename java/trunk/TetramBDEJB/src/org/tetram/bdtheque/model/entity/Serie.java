package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.sql.Blob;
import java.util.List;

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
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Where;

@Entity
@Table(name = "series")
public class Serie implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@GeneratedValue
	@Id
	@Column(name = "id_serie")
	private String id;

	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_editeur")
	private Editeur editeur;

	@ManyToOne(optional = true, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_collection")
	private Collection collection;

	private Boolean terminee;
	private Boolean complete;
	private String siteWeb;
	private Boolean suivreManquants;
	private Boolean suivreSorties;
	private Boolean vo;
	private Boolean couleur;
	@NotNull
	@Column(name = "titreserie", nullable = false)
	private String titre;
	@Lob
	@Column(name = "sujetserie")
	private Blob sujet;
	@Lob
	@Column(name = "remarquesserie")
	private Blob commentaires;
	@Column(name = "nb_albums")
	private Integer nbAlbums;

	@Embedded
	private ConfigurationEdition etat;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "genreseries", joinColumns = @JoinColumn(name = "id_serie"), inverseJoinColumns = @JoinColumn(name = "id_genre"))
	private List<Genre> genres;

	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_serie", insertable = false, updatable = false)
	@Where(clause = "metier=0")
	private List<ScenaristeSerie> scenaristes;
	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_serie", insertable = false, updatable = false)
	@Where(clause = "metier=1")
	private List<DessinateurSerie> dessinateurs;
	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_serie", insertable = false, updatable = false)
	@Where(clause = "metier=2")
	private List<ColoristeSerie> coloristes;

	@OneToMany(mappedBy = "serie", fetch = FetchType.LAZY)
	private List<ParaBD> paraBD;

	protected String getId() {
		return id;
	}

	protected void setId(String id) {
		this.id = id;
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

	protected Boolean getTerminee() {
		return terminee;
	}

	protected void setTerminee(Boolean terminee) {
		this.terminee = terminee;
	}

	protected Boolean getComplete() {
		return complete;
	}

	protected void setComplete(Boolean complete) {
		this.complete = complete;
	}

	protected String getSiteWeb() {
		return siteWeb;
	}

	protected void setSiteWeb(String siteWeb) {
		this.siteWeb = siteWeb;
	}

	protected Boolean getSuivreManquants() {
		return suivreManquants;
	}

	protected void setSuivreManquants(Boolean suivreManquants) {
		this.suivreManquants = suivreManquants;
	}

	protected Boolean getSuivreSorties() {
		return suivreSorties;
	}

	protected void setSuivreSorties(Boolean suivreSorties) {
		this.suivreSorties = suivreSorties;
	}

	protected Integer getNbAlbums() {
		return nbAlbums;
	}

	protected void setNbAlbums(Integer nbAlbums) {
		this.nbAlbums = nbAlbums;
	}

	protected ConfigurationEdition getEtat() {
		return etat;
	}

	protected void setEtat(ConfigurationEdition etat) {
		this.etat = etat;
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

	protected String getTitre() {
		return titre;
	}

	protected void setTitre(String titre) {
		this.titre = titre;
	}

	protected String getSujet() {
		return sujet.toString();
	}

	protected void setSujet(Blob sujet) {
		this.sujet = sujet;
	}

	protected Blob getCommentaires() {
		return commentaires;
	}

	protected void setCommentaires(Blob commentaires) {
		this.commentaires = commentaires;
	}

	protected List<Genre> getGenres() {
		return genres;
	}

	protected void setGenres(List<Genre> genres) {
		this.genres = genres;
	}

	protected List<ParaBD> getParaBD() {
		return paraBD;
	}

	protected void setParaBD(List<ParaBD> paraBD) {
		this.paraBD = paraBD;
	}

	protected List<ScenaristeSerie> getScenaristes() {
		return scenaristes;
	}

	protected void setScenaristes(List<ScenaristeSerie> scenaristes) {
		this.scenaristes = scenaristes;
	}

	protected List<DessinateurSerie> getDessinateurs() {
		return dessinateurs;
	}

	protected void setDessinateurs(List<DessinateurSerie> dessinateurs) {
		this.dessinateurs = dessinateurs;
	}

	protected List<ColoristeSerie> getColoristes() {
		return coloristes;
	}

	protected void setColoristes(List<ColoristeSerie> coloristes) {
		this.coloristes = coloristes;
	}

}
