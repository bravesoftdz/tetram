package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.NaturalId;

@Entity
@Table(name = "cotes")
public class CoteEdition implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@GeneratedValue
	@Id
	@Column(name = "id_cote")
	private String id;

	@Embedded
	private Cote cote;

	@NaturalId
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "id_edition")
	private Edition edition;

	protected String getId() {
		return id;
	}

	protected void setId(String id) {
		this.id = id;
	}

	protected Cote getCote() {
		return cote;
	}

	protected void setCote(Cote cote) {
		this.cote = cote;
	}

	protected Edition getEdition() {
		return edition;
	}

	protected void setEdition(Edition edition) {
		this.edition = edition;
	}
}
