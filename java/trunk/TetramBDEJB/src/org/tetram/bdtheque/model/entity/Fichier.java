package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.sql.Blob;

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
  private Blob image;
  private boolean stockage;
  private String fichier;

  public Blob getImage() {
    return image;
  }

  public void setImage(Blob image) {
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
