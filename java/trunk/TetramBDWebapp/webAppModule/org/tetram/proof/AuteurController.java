package org.tetram.proof;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.ejb.EJB;
import javax.ejb.Stateful;
import javax.enterprise.inject.Produces;
import javax.inject.Inject;
import javax.inject.Named;

import org.jboss.seam.faces.context.RenderScoped;
import org.jboss.seam.international.status.Messages;
import org.tetram.bdtheque.model.entity.Auteur;
import org.tetram.bdtheque.service.local.AuteurServiceLocal;

@Named
@Stateful
@RenderScoped
public class AuteurController {

	@EJB
	AuteurServiceLocal auteurService;

	@Inject
	Messages messages;

	private List<Auteur> zoneCodes = new ArrayList<Auteur>();

	/**
	 * Perform search This retrieves all ZoneCodes from database
	 */
	public void search() {
		Date debut = new Date();
		zoneCodes = auteurService.findAll();
		messages.info("Search completed. {0} records found ({1} ms)", zoneCodes.size(), new Date().getTime() - debut.getTime());
	}

	/**
	 * Reset results
	 */
	public void reset() {
		zoneCodes = new ArrayList<Auteur>();
	}

	// out-jection
	@Produces
	@Named
	public List<Auteur> getZoneCodes() {
		return zoneCodes;
	}
}
