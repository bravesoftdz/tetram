package org.tetram.bdtheque.model.entity;

import java.io.Serializable;

import javax.persistence.Embeddable;

@Embeddable
public class Monnaie implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String symbole;

	protected String getSymbole() {
		return symbole;
	}

	protected void setSymbole(String symbole) {
		this.symbole = symbole;
	}
}
