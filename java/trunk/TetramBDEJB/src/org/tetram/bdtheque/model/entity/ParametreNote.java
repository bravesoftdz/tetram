package org.tetram.bdtheque.model.entity;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("9")
public class ParametreNote extends ParametreListe {

  /**
	 * 
	 */
  private static final long serialVersionUID = 1L;

}
