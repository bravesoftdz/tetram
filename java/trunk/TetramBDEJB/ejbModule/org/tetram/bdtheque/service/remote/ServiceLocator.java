package org.tetram.bdtheque.service.remote;

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

public class ServiceLocator {
	private static ServiceLocator me;
	InitialContext context = null;

	private ServiceLocator() throws NamingException {
		Hashtable<String, String> jndiProperties = new Hashtable<String, String>();
		jndiProperties.put(Context.URL_PKG_PREFIXES,
				"org.jboss.ejb.client.naming");
		this.context = new InitialContext(jndiProperties);
	}

	// Returns the instance of ServiceLocator class
	public static ServiceLocator getInstance() throws NamingException {
		if (me == null) {
			me = new ServiceLocator();
		}
		return me;
	}

	private static String buildEjbName(Class<?> classToBuild, boolean stateful)
			throws NamingException {
		// The app name is the application name of the deployed EJBs. This is
		// typically the ear name
		// without the .ear suffix. However, the application name could be
		// overridden in the application.xml of the
		// EJB deployment on the server.
		// Since we haven't deployed the application as a .ear, the app name for
		// us will be an empty string
		final String appName = "TetramBDTheque";
		// This is the module name of the deployed EJBs on the server. This is
		// typically the jar name of the
		// EJB deployment, without the .jar suffix, but can be overridden via
		// the ejb-jar.xml
		// In this example, we have deployed the EJBs in a
		// jboss-as-ejb-remote-app.jar, so the module name is
		// jboss-as-ejb-remote-app
		final String moduleName = "TetramBDEJB";
		// AS7 allows each deployment to have an (optional) distinct name. We
		// haven't specified a distinct name for
		// our EJB deployment, so this is an empty string
		final String distinctName = "";
		// The EJB name which by default is the simple class name of the bean
		// implementation class
		String beanName = classToBuild.getSimpleName();
		beanName = String.valueOf(beanName.charAt(0)).toLowerCase()
				+ beanName.substring(1);
		// the remote view fully qualified class name
		final String viewClassName = classToBuild.getName();
		// let's do the lookup
		final String ejbName = "ejb:" + appName + "/" + moduleName + "/"
				+ distinctName + "/" + beanName + "!" + viewClassName
				+ (stateful ? "?stateful" : "");

		System.out.println("ejbName : " + ejbName);

		return ejbName;
	}

	public Object lookup(String ejbName) {
		try {
			// if (commonPrefix != null) name = commonPrefix + "/" +name;
			return context.lookup(ejbName);
		} catch (NamingException e) {
			throw new IllegalArgumentException(e);
		}
	}

	@SuppressWarnings("unchecked")
	public <T> T lookup(Class<T> type, boolean stateful) throws NamingException {
		return (T) lookup(buildEjbName(type, stateful));
	}

}
