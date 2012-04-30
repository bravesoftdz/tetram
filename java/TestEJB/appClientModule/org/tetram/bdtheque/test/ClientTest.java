package org.tetram.bdtheque.test;

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.tetram.bdtheque.model.entity.Auteur;
import org.tetram.bdtheque.service.AuteurService;

public class ClientTest {

	public static void main(String[] args) throws NamingException {
		ClientTest test = new ClientTest();
		test.doTest();
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

	@SuppressWarnings("unchecked")
	private static <T> T lookupRemoteStateless(Class<?> classToFind)
			throws NamingException {
		Hashtable<String, String> jndiProperties = new Hashtable<String, String>();
		jndiProperties.put(Context.URL_PKG_PREFIXES,
				"org.jboss.ejb.client.naming");
		Context context = new InitialContext(jndiProperties);

		final Object lookup = context.lookup(buildEjbName(classToFind));
		return (T) lookup;
	}

	@SuppressWarnings("unchecked")
	private static <T> T lookupRemoteStateful(Class<?> classToFind)
			throws NamingException {
		Hashtable<String, String> jndiProperties = new Hashtable<String, String>();
		jndiProperties.put(Context.URL_PKG_PREFIXES,
				"org.jboss.ejb.client.naming");
		Context context = new InitialContext(jndiProperties);

		final Object lookup = context.lookup(buildEjbName(classToFind)
				+ "?stateful");
		return (T) lookup;
	}

	private void doTest() throws NamingException {
		AuteurService auteurService = lookupRemoteStateful(AuteurService.class);
		System.out.println(auteurService == null ? "not assigned" : "assigned");
		System.out.println(auteurService);

		Auteur auteur = auteurService
				.getAuteur("{0D603312-BA1A-467D-A572-F76FB3FFBA18}");
		System.out.println(auteur == null ? "not assigned" : "assigned");
		System.out.println(auteur.toString());
	}

}