package org.tetram.bdtheque.test;

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.tetram.bdtheque.model.entity.Album;
import org.tetram.bdtheque.model.entity.Auteur;
import org.tetram.bdtheque.service.AlbumService;
import org.tetram.bdtheque.service.AuteurService;

public class ClientTest {

	private static final String id_album = "{0D603312-BA1A-467D-A572-F76FB3FFBA18}";
	private static final String id_auteur = "{88F9D09B-4C3E-4291-B7BB-ED14DAE7624A}";

	public static void main(String[] args) throws NamingException {
		ClientTest test = new ClientTest();
		test.doTestAlbum();
	}

	public ClientTest() {
		super();
	}

	private static String buildEjbName(Class<?> classToBuild)
			throws NamingException {
		// The app name is the application name of the deployed EJBs. This is
		// typically the ear name
		// without the .ear suffix. However, the application name could be
		// overridden in the application.xml of the
		// EJB deployment on the server.
		// Since we haven't deployed the application as a .ear, the app name for
		// us will be an empty string
		String appName = "";
		// This is the module name of the deployed EJBs on the server. This is
		// typically the jar name of the
		// EJB deployment, without the .jar suffix, but can be overridden via
		// the ejb-jar.xml
		// In this example, we have deployed the EJBs in a
		// jboss-as-ejb-remote-app.jar, so the module name is
		// jboss-as-ejb-remote-app
		String moduleName = "TetramBDEJB";
		// AS7 allows each deployment to have an (optional) distinct name. We
		// haven't specified a distinct name for
		// our EJB deployment, so this is an empty string
		String distinctName = "";
		// The EJB name which by default is the simple class name of the bean
		// implementation class
		String beanName = classToBuild.getSimpleName();
		beanName = String.valueOf(beanName.charAt(0)).toLowerCase()
				+ beanName.substring(1);
		// the remote view fully qualified class name
		String viewClassName = classToBuild.getName();
		// let's do the lookup
		String ejbName = "ejb:" + appName + "/" + moduleName + "/"
				+ distinctName + "/" + beanName + "!" + viewClassName;

		System.out.println("ejbName : " + ejbName);

		return ejbName;
	}

	@SuppressWarnings({ "unchecked" })
	protected static <T> T lookupRemoteStateless(Class<?> classToFind)
			throws NamingException {
		Hashtable<String, String> jndiProperties = new Hashtable<String, String>();
		jndiProperties.put(Context.URL_PKG_PREFIXES,
				"org.jboss.ejb.client.naming");
		Context context = new InitialContext(jndiProperties);

		final Object lookup = context.lookup(buildEjbName(classToFind));
		return (T) lookup;
	}

	@SuppressWarnings({ "unchecked" })
	protected static <T> T lookupRemoteStateful(Class<?> classToFind)
			throws NamingException {
		Hashtable<String, String> jndiProperties = new Hashtable<String, String>();
		jndiProperties.put(Context.URL_PKG_PREFIXES,
				"org.jboss.ejb.client.naming");
		Context context = new InitialContext(jndiProperties);

		final Object lookup = context.lookup(buildEjbName(classToFind)
				+ "?stateful");
		return (T) lookup;
	}

	public void doTestAuteur() throws NamingException {
		AuteurService auteurService = lookupRemoteStateless(AuteurService.class);
		System.out.println(auteurService == null ? "not assigned" : "assigned");
		System.out.println(auteurService);

		Auteur auteur = auteurService
				.getAuteur(id_auteur);
		System.out.println(auteur == null ? "not assigned" : "assigned");
		System.out.println(auteur.getNom().getTitre());
	}

	public void doTestAlbum() throws NamingException {
		AlbumService albumService = lookupRemoteStateless(AlbumService.class);
		System.out.println(albumService == null ? "not assigned" : "assigned");
		System.out.println(albumService);

		Album album = albumService
				.getAlbum(id_album);
		System.out.println(album == null ? "not assigned" : "assigned");
		System.out.println(album.getTitre().getTitre());
	}

}