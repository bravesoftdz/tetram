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

	@Column(columnDefinition = "numeric(15,2)")
	private BigDecimal taux;

	@Embedded
	@AttributeOverride(name = "symbole", column = @Column(name = "monnaie1"))
	private Monnaie monnaie1;
	
	@Embedded
	@AttributeOverride(name = "symbole", column = @Column(name = "monnaie2"))
	private Monnaie monnaie2;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public BigDecimal getTaux() {
		return taux;
	}

	public void setTaux(BigDecimal taux) {
		this.taux = taux;
	}

	public Monnaie getMonnaie1() {
		return monnaie1;
	}

	public void setMonnaie1(Monnaie monnaie1) {
		this.monnaie1 = monnaie1;
	}

	public Monnaie getMonnaie2() {
		return monnaie2;
	}

	public void setMonnaie2(Monnaie monnaie2) {
		this.monnaie2 = monnaie2;
	}

}
