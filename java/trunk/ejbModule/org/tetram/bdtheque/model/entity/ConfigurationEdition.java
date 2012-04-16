package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.Embeddable;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import org.hibernate.annotations.Where;

@Embeddable
public class ConfigurationEdition implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "etat", insertable = false, updatable = false)
	@Where(clause = "categorie=1")
	private ParametreEtat etat;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "reliure", insertable = false, updatable = false)
	@Where(clause = "categorie=2")
	private ParametreReliure reliure;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "typeedition", insertable = false, updatable = false)
	@Where(clause = "categorie=3")
	private ParametreEdition edition;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "orientation", insertable = false, updatable = false)
	@Where(clause = "categorie=4")
	private ParametreOrientation orientation;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "formatedition", insertable = false, updatable = false)
	@Where(clause = "categorie=5")
	private ParametreFormat format;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "senslecture", insertable = false, updatable = false)
	@Where(clause = "categorie=8")
	private ParametreSensLecture sensLecture;

	protected ParametreEtat getEtat() {
		return etat;
	}

	protected void setEtat(ParametreEtat etat) {
		this.etat = etat;
	}

	protected ParametreOrientation getOrientation() {
		return orientation;
	}

	protected void setOrientation(ParametreOrientation orientation) {
		this.orientation = orientation;
	}

	protected ParametreEdition getEdition() {
		return edition;
	}

	protected void setEdition(ParametreEdition edition) {
		this.edition = edition;
	}

	protected ParametreFormat getFormat() {
		return format;
	}

	protected void setFormat(ParametreFormat format) {
		this.format = format;
	}

	protected ParametreSensLecture getSensLecture() {
		return sensLecture;
	}

	protected void setSensLecture(ParametreSensLecture sensLecture) {
		this.sensLecture = sensLecture;
	}

	protected ParametreReliure getReliure() {
		return reliure;
	}

	protected void setReliure(ParametreReliure reliure) {
		this.reliure = reliure;
	}

}
