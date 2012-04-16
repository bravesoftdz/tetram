package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "conversions")
public class TauxConversion implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "id_conversion")
	private String id;

	private BigDecimal taux;

	@Embedded
	@AttributeOverride(name = "symbole", column = @Column(name = "monnaie1"))
	private Monnaie monnaie1;
	@Embedded
	@AttributeOverride(name = "symbole", column = @Column(name = "monnaie2"))
	private Monnaie monnaie2;

	protected String getId() {
		return id;
	}

	protected void setId(String id) {
		this.id = id;
	}

	protected BigDecimal getTaux() {
		return taux;
	}

	protected void setTaux(BigDecimal taux) {
		this.taux = taux;
	}

	protected Monnaie getMonnaie1() {
		return monnaie1;
	}

	protected void setMonnaie1(Monnaie monnaie1) {
		this.monnaie1 = monnaie1;
	}

	protected Monnaie getMonnaie2() {
		return monnaie2;
	}

	protected void setMonnaie2(Monnaie monnaie2) {
		this.monnaie2 = monnaie2;
	}

}
