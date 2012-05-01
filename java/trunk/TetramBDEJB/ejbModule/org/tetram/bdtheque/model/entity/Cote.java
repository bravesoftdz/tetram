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
	@Column(name = "prixcote", columnDefinition = "numeric(15,2)")
	private BigDecimal prix;

	public Integer getAnnee() {
		return annee;
	}

	public void setAnnee(Integer annee) {
		this.annee = annee;
	}

	public BigDecimal getPrix() {
		return prix;
	}

	public void setPrix(BigDecimal prix) {
		this.prix = prix;
	}
}
