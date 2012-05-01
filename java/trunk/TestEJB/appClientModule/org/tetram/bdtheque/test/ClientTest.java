package org.tetram.bdtheque.test;

import javax.naming.NamingException;

import org.tetram.bdtheque.model.entity.Album;
import org.tetram.bdtheque.model.entity.Auteur;
import org.tetram.bdtheque.service.ServiceLocator;
import org.tetram.bdtheque.service.remote.AlbumService;
import org.tetram.bdtheque.service.remote.AuteurService;

public class ClientTest {

	private static final String id_album = "{0D603312-BA1A-467D-A572-F76FB3FFBA18}";
	private static final String id_auteur = "{88F9D09B-4C3E-4291-B7BB-ED14DAE7624A}";

	public static void main(String[] args) throws NamingException {
		ClientTest test = new ClientTest();
		test.doTestAuteur();
	}

	public ClientTest() {
		super();
	}

	public void doTestAlbum() throws NamingException {
		AlbumService albumService = ServiceLocator.getInstance().lookup(
				AlbumService.class, false);
		System.out.println("albumService : "
				+ (albumService == null ? "not assigned" : "assigned"));
		System.out.println("albumService : " + albumService);

		Album album = albumService.getAlbum(id_album);
		System.out.println("album : "
				+ (album == null ? "not assigned" : "assigned"));
		System.out.println("album : " + album.getTitre().getTitre());
	}

	public void doTestAuteur() throws NamingException {
		AuteurService auteurService = ServiceLocator.getInstance().lookup(
				AuteurService.class, true);
		System.out.println("auteurService : "
				+ (auteurService == null ? "not assigned" : "assigned"));
		System.out.println("auteurService : " + auteurService);

		Auteur auteur = auteurService.getAuteur(id_auteur);
		System.out.println("auteur : "
				+ (auteur == null ? "not assigned" : "assigned"));
		System.out.println("auteur : " + auteur.getNom().getTitre());
	}

}