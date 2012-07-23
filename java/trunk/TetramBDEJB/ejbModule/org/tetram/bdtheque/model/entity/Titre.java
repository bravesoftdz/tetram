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
	@Transient
	private String formattedTitre;

	@Access(AccessType.PROPERTY)
	public String getTitre() {
		return titre;
	}

	private static String formatTitre(final String titre) {
		String result = titre.trim();
		int i = result.indexOf('[');
		if (i > -1) {
			int j = result.indexOf(']', i);
			if (j != -1) {
				String dummy = result.substring(i + 1, j).trim();
				if (dummy.length() > 0) {
					if (!dummy.endsWith("'"))
						dummy += " ";
				}
				result = dummy + result.substring(0, i) + " "
						+ result.substring(j + 1);
			}
		}
		return result;
	}

	public void setTitre(String titre) {
		this.titre = titre;
		if (titre == null) {
			upperTitre = null;
			initialeTitre = null;
			formattedTitre = null;
		} else {
			upperTitre = titre.toUpperCase();
			initialeTitre = titre.charAt(0);
			if (!Character.isLetterOrDigit(initialeTitre))
				initialeTitre = '#';
			formattedTitre = formatTitre(titre);
		}
	}

	public Character getInitialeTitre() {
		return initialeTitre;
	}

	public String getUpperTitre() {
		return upperTitre;
	}

	public String getFormattedTitre() {
		return formattedTitre;
	}

}
