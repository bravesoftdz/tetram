package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Embeddable;
import javax.persistence.Transient;

@Embeddable
public class Titre implements Serializable {

	/**
   * 
   */
	private static final long serialVersionUID = 1L;

	private String titre;
	private Character initialeTitre;
	@Transient
	private String upperTitre;

	@Access(AccessType.PROPERTY)
	public String getTitre() {
		return titre;
	}

	public void setTitre(String titre) {
		this.titre = titre;
		if (titre == null) {
			upperTitre = null;
			initialeTitre = null;
		} else {
			upperTitre = titre.toUpperCase();
			initialeTitre = titre.charAt(0);
			if (!Character.isLetterOrDigit(initialeTitre))
				initialeTitre = '#';
		}
	}

	public Character getInitialeTitre() {
		return initialeTitre;
	}

	public String getUpperTitre() {
		return upperTitre;
	}

}
