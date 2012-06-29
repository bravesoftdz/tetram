package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.sql.Blob;
import java.util.List;
import java.util.Set;

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
	@AttributeOverrides({
			@AttributeOverride(name = "titre", column = @Column(name = "titreserie", nullable = false, length = 150)),
			@AttributeOverride(name = "initialeTitre", column = @Column(name = "initialetitreserie", nullable = false)) })
	private Titre titre;
	@Lob
	@Column(name = "sujetserie")
	private Blob sujet;
	@Lob
	@Column(name = "remarquesserie")
	private Blob commentaires;
	@Column(name = "nb_albums")
	private Integer nbAlbums;

	@OneToMany(mappedBy = "serie", fetch = FetchType.LAZY)
	private Set<Album> albums;

	@Embedded
	private ConfigurationEdition etat;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "genreseries", joinColumns = @JoinColumn(name = "id_serie"), inverseJoinColumns = @JoinColumn(name = "id_genre"))
	private Set<Genre> genres;

	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_serie", insertable = false, updatable = false)
	@Where(clause = "metier=0")
	private Set<ScenaristeSerie> scenaristes;
	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_serie", insertable = false, updatable = false)
	@Where(clause = "metier=1")
	private Set<DessinateurSerie> dessinateurs;
	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_serie", insertable = false, updatable = false)
	@Where(clause = "metier=2")
	private Set<ColoristeSerie> coloristes;

	@ManyToOne
	@JoinColumn(name = "notation", insertable = false, updatable = false)
	@Where(clause = "categorie=9")
	private ParametreNote notation;

	@OneToMany(mappedBy = "serie", fetch = FetchType.LAZY)
	private Set<ParaBD> paraBD;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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

	public Boolean getTerminee() {
		return terminee;
	}

	public void setTerminee(Boolean terminee) {
		this.terminee = terminee;
	}

	public Boolean getComplete() {
		return complete;
	}

	public void setComplete(Boolean complete) {
		this.complete = complete;
	}

	public String getSiteWeb() {
		return siteWeb;
	}

	public void setSiteWeb(String siteWeb) {
		this.siteWeb = siteWeb;
	}

	public Boolean getSuivreManquants() {
		return suivreManquants;
	}

	public void setSuivreManquants(Boolean suivreManquants) {
		this.suivreManquants = suivreManquants;
	}

	public Boolean getSuivreSorties() {
		return suivreSorties;
	}

	public void setSuivreSorties(Boolean suivreSorties) {
		this.suivreSorties = suivreSorties;
	}

	public Integer getNbAlbums() {
		return nbAlbums;
	}

	public void setNbAlbums(Integer nbAlbums) {
		this.nbAlbums = nbAlbums;
	}

	public ConfigurationEdition getEtat() {
		return etat;
	}

	public void setEtat(ConfigurationEdition etat) {
		this.etat = etat;
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

	public Titre getTitre() {
		return titre;
	}

	public void setTitre(Titre titre) {
		this.titre = titre;
	}

	public String getSujet() {
		return sujet.toString();
	}

	public void setSujet(Blob sujet) {
		this.sujet = sujet;
	}

	public Blob getCommentaires() {
		return commentaires;
	}

	public void setCommentaires(Blob commentaires) {
		this.commentaires = commentaires;
	}

	public Set<Genre> getGenres() {
		return genres;
	}

	public void setGenres(Set<Genre> genres) {
		this.genres = genres;
	}

	public Set<ParaBD> getParaBD() {
		return paraBD;
	}

	public void setParaBD(Set<ParaBD> paraBD) {
		this.paraBD = paraBD;
	}

	public Set<ScenaristeSerie> getScenaristes() {
		return scenaristes;
	}

	public void setScenaristes(Set<ScenaristeSerie> scenaristes) {
		this.scenaristes = scenaristes;
	}

	public Set<DessinateurSerie> getDessinateurs() {
		return dessinateurs;
	}

	public void setDessinateurs(Set<DessinateurSerie> dessinateurs) {
		this.dessinateurs = dessinateurs;
	}

	public Set<ColoristeSerie> getColoristes() {
		return coloristes;
	}

	public void setColoristes(Set<ColoristeSerie> coloristes) {
		this.coloristes = coloristes;
	}

	protected Set<Album> getAlbums() {
		return albums;
	}

	protected void setAlbums(Set<Album> albums) {
		this.albums = albums;
	}

	public ParametreNote getNotation() {
		return notation;
	}

	public void setNotation(ParametreNote notation) {
		this.notation = notation;
	}

}
