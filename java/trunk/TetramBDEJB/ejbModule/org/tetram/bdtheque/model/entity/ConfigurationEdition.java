package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import org.hibernate.annotations.Where;

@Embeddable
@Access(AccessType.PROPERTY)
public class ConfigurationEdition implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private ParametreEtat etat;
	private ParametreReliure reliure;
	private ParametreEdition edition;
	private ParametreOrientation orientation;
	private ParametreFormat format;
	private ParametreSensLecture sensLecture;

	@ManyToOne
	// (fetch = FetchType.LAZY)
	@JoinColumn(name = "typeedition", insertable = false, updatable = false)
	@Where(clause = "categorie=3")
	public ParametreEdition getEdition() {
		return edition;
	}

	@ManyToOne
	// (fetch = FetchType.LAZY)
	@JoinColumn(name = "etat", insertable = false, updatable = false)
	@Where(clause = "categorie=1")
	public ParametreEtat getEtat() {
		return etat;
	}

	@ManyToOne
	// (fetch = FetchType.LAZY)
	@JoinColumn(name = "formatedition", insertable = false, updatable = false)
	@Where(clause = "categorie=5")
	public ParametreFormat getFormat() {
		return format;
	}

	@ManyToOne
	// (fetch = FetchType.LAZY)
	@JoinColumn(name = "orientation", insertable = false, updatable = false)
	@Where(clause = "categorie=4")
	public ParametreOrientation getOrientation() {
		return orientation;
	}

	@ManyToOne
	// (fetch = FetchType.LAZY)
	@JoinColumn(name = "reliure", insertable = false, updatable = false)
	@Where(clause = "categorie=2")
	public ParametreReliure getReliure() {
		return reliure;
	}

	@ManyToOne
	// (fetch = FetchType.LAZY)
	@JoinColumn(name = "senslecture", insertable = false, updatable = false)
	@Where(clause = "categorie=8")
	public ParametreSensLecture getSensLecture() {
		return sensLecture;
	}

	public void setEdition(ParametreEdition edition) {
		this.edition = edition;
	}

	public void setEtat(ParametreEtat etat) {
		this.etat = etat;
	}

	public void setFormat(ParametreFormat format) {
		this.format = format;
	}

	public void setOrientation(ParametreOrientation orientation) {
		this.orientation = orientation;
	}

	public void setReliure(ParametreReliure reliure) {
		this.reliure = reliure;
	}

	public void setSensLecture(ParametreSensLecture sensLecture) {
		this.sensLecture = sensLecture;
	}

}
