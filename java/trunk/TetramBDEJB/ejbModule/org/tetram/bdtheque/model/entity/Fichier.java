package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Lob;

@Embeddable
public class Fichier implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Lob
	@Column(nullable = true)
	private Byte[] image;
	
	@Basic
	private boolean stockage;
	
	@Basic(optional = false)
	private String fichier;

	public Byte[] getImage() {
		return image;
	}

	public void setImage(Byte[] image) {
		this.image = image;
	}

	public boolean isStockage() {
		return stockage;
	}

	public void setStockage(boolean stockage) {
		this.stockage = stockage;
	}

	public String getFichier() {
		return fichier;
	}

	public void setFichier(String fichier) {
		this.fichier = fichier;
	}
}
