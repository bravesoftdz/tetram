package org.tetram.bdtheque.model.entity;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("1")
public class DessinateurSerie extends AuteurSerie {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

}
