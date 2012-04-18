package org.tetram.bdtheque.model.entity;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("4")
public class ParametreOrientation extends ParametreListe {

  /**
	 * 
	 */
  private static final long serialVersionUID = 1L;

}
