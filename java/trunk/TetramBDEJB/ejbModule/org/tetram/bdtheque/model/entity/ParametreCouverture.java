package org.tetram.bdtheque.model.entity;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("6")
public class ParametreCouverture extends ParametreListe {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

}
