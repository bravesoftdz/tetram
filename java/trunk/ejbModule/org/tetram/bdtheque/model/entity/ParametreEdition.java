package org.tetram.bdtheque.model.entity;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

import org.tetram.bdtheque.model.entity.ParametreListe;

@Entity
@DiscriminatorValue("3")
public class ParametreEdition extends ParametreListe {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

}
