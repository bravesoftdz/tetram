package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import org.hibernate.annotations.NaturalId;

@Embeddable
public class Cote implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@NaturalId
	@Column(name = "anneecote")
	private Integer annee;
	@Column(name = "prixcote")
	private BigDecimal prix;

	protected Integer getAnnee() {
		return annee;
	}

	protected void setAnnee(Integer annee) {
		this.annee = annee;
	}

	protected BigDecimal getPrix() {
		return prix;
	}

	protected void setPrix(BigDecimal prix) {
		this.prix = prix;
	}
}
