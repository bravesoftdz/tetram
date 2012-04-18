package org.tetram.bdtheque.model.entity;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("2")
public class ParametreReliure extends ParametreListe {

  /**
	 * 
	 */
  private static final long serialVersionUID = 1L;

}
