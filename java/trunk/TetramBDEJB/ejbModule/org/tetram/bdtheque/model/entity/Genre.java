package org.tetram.bdtheque.model.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "genres")
public class Genre implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@GeneratedValue
	@Id
	@Column(name = "id_genre")
	private String id;
	@NotNull
	@AttributeOverrides({
			@AttributeOverride(name = "titre", column = @Column(name = "genre", nullable = false, length = 30)),
			@AttributeOverride(name = "initialeTitre", column = @Column(name = "initialegenre", nullable = false)) })
	private Titre nom;

	@ManyToMany(fetch = FetchType.LAZY, cascade = { CascadeType.PERSIST,
			CascadeType.MERGE }, mappedBy = "genres")
	private List<Serie> series;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Titre getNom() {
		return nom;
	}

	public void setNom(Titre nom) {
		this.nom = nom;
	}

	public List<Serie> getSeries() {
		return series;
	}

	public void setSeries(List<Serie> series) {
		this.series = series;
	}

}
