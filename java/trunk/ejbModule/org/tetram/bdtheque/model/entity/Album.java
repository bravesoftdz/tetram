package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.sql.Blob;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Where;

@Entity
@Table(name = "albums")
public class Album implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@GeneratedValue
	@Id
	@Column(name = "id_album")
	private String id;

	private Integer moisParution;
	private Integer anneeParution;

	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "id_serie")
	private Serie serie;

	private Integer tome;
	private Integer tomeDebut;
	private Integer tomeFin;

	private boolean horsSerie;
	private boolean achat;
	private int nbEditions;
	@OneToMany(mappedBy = "album", fetch = FetchType.LAZY)
	private List<Edition> editions;
	private boolean complet;

	@Column(name = "titrealbum", nullable = false)
	private String titre;
	@Lob
	@Column(name = "sujetalbum")
	private Blob resume;
	@Lob
	@Column(name = "remarquesalbum")
	private Blob commentaires;

	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_album", insertable = false, updatable = false)
	@Where(clause = "metier=0")
	private List<ScenaristeAlbum> scenaristes;
	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_album", insertable = false, updatable = false)
	@Where(clause = "metier=1")
	private List<DessinateurAlbum> dessinateurs;
	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_album", insertable = false, updatable = false)
	@Where(clause = "metier=2")
	private List<ColoristeAlbum> coloristes;

	protected String getId() {
		return id;
	}

	protected void setId(String id) {
		this.id = id;
	}

	protected Integer getMoisParution() {
		return moisParution;
	}

	protected void setMoisParution(Integer moisParution) {
		this.moisParution = moisParution;
	}

	protected Integer getAnneeParution() {
		return anneeParution;
	}

	protected void setAnneeParution(Integer anneeParution) {
		this.anneeParution = anneeParution;
	}

	protected Serie getSerie() {
		return serie;
	}

	protected void setSerie(Serie serie) {
		this.serie = serie;
	}

	protected Integer getTome() {
		return tome;
	}

	protected void setTome(Integer tome) {
		this.tome = tome;
	}

	protected Integer getTomeDebut() {
		return tomeDebut;
	}

	protected void setTomeDebut(Integer tomeDebut) {
		this.tomeDebut = tomeDebut;
	}

	protected Integer getTomeFin() {
		return tomeFin;
	}

	protected void setTomeFin(Integer tomeFin) {
		this.tomeFin = tomeFin;
	}

	protected boolean isHorsSerie() {
		return horsSerie;
	}

	protected void setHorsSerie(boolean horsSerie) {
		this.horsSerie = horsSerie;
	}

	protected boolean isAchat() {
		return achat;
	}

	protected void setAchat(boolean achat) {
		this.achat = achat;
	}

	protected int getNbEditions() {
		return nbEditions;
	}

	protected void setNbEditions(int nbEditions) {
		this.nbEditions = nbEditions;
	}

	protected List<Edition> getEditions() {
		return editions;
	}

	protected void setEditions(List<Edition> editions) {
		this.editions = editions;
	}

	protected boolean isComplet() {
		return complet;
	}

	protected void setComplet(boolean complet) {
		this.complet = complet;
	}

	protected String getTitre() {
		return titre;
	}

	protected void setTitre(String titre) {
		this.titre = titre;
	}

	protected Blob getResume() {
		return resume;
	}

	protected void setResume(Blob resume) {
		this.resume = resume;
	}

	protected Blob getCommentaires() {
		return commentaires;
	}

	protected void setCommentaires(Blob commentaires) {
		this.commentaires = commentaires;
	}

	protected List<ScenaristeAlbum> getScenaristes() {
		return scenaristes;
	}

	protected void setScenaristes(List<ScenaristeAlbum> scenaristes) {
		this.scenaristes = scenaristes;
	}

	protected List<DessinateurAlbum> getDessinateurs() {
		return dessinateurs;
	}

	protected void setDessinateurs(List<DessinateurAlbum> dessinateurs) {
		this.dessinateurs = dessinateurs;
	}

	protected List<ColoristeAlbum> getColoristes() {
		return coloristes;
	}

	protected void setColoristes(List<ColoristeAlbum> coloristes) {
		this.coloristes = coloristes;
	}

}
