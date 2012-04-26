package org.tetram.bdtheque.test;

import java.util.Hashtable;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.tetram.bdtheque.model.dao.AlbumDao;
import org.tetram.bdtheque.model.dao.BDthequeDaoFactory;
import org.tetram.bdtheque.model.entity.Album;
import org.tetram.bdtheque.service.AlbumService;

public class ClientTest {

  /**
   * @param args
   * @throws NamingException
   * @throws NoSuchFieldException
   * @throws IllegalAccessException
   * @throws SecurityException
   * @throws IllegalArgumentException
   */
  public static void main(String[] args)
      throws NamingException,
        IllegalArgumentException,
        SecurityException,
        IllegalAccessException,
        NoSuchFieldException {

    final AlbumService al = lookupRemoteStateless(AlbumService.class);
    Logger.getLogger(ClientTest.class.getName()).log(Level.INFO, "instance obtenue");

    // Logger.getLogger(ClientTest.class.getName()).log(Level.INFO,
    // "before getlist");
    // Map<Object, List<Album>> list = al.getListByAnnee();
    // Logger.getLogger(ClientTest.class.getName()).log(Level.INFO,
    // "after getlist");
    // Logger.getLogger(ClientTest.class.getName()).log(Level.INFO,
    // String.valueOf(list.size()));

    // final FactoryOfDaoFactories factoryOfFactories = lookupRemoteStateless(FactoryOfDaoFactories.class);
    // final BDthequeDaoFactory factory = factoryOfFactories.createBDthequeDaoFactory();
    final BDthequeDaoFactory factory = al.getbdthequeDaoFactory();
    AlbumDao albumDao = factory.getAlbumDao();
    Album a = albumDao.findById("");

    Logger.getLogger(ClientTest.class.getName()).log(Level.INFO, a.getId());
  }

  private static String buildEjbName(Class<?> e) {
    // The app name is the application name of the deployed EJBs. This is
    // typically the ear name without the .ear suffix. However, the application
    // name could be overridden in the application.xml of the EJB deployment on
    // the server.
    // Since we haven't deployed the application as a .ear, the app name for us
    // will be an empty string
    final String appName = "";
    // This is the module name of the deployed EJBs on the server. This is
    // typically the jar name of the EJB deployment, without the .jar suffix,
    // but can be overridden via the ejb-jar.xml
    final String moduleName = "TetramBDEJB";
    // AS7 allows each deployment to have an (optional) distinct name. We
    // haven't specified a distinct name for our EJB deployment, so this is an
    // empty string
    final String distinctName = "";
    // The EJB name which by default is the simple class name of the bean
    // implementation class
    String beanName = e.getSimpleName();
    beanName = String.valueOf(beanName.charAt(0)).toLowerCase() + beanName.substring(1);
    // the remote view fully qualified class name
    final String viewClassName = e.getCanonicalName();
    // let's do the lookup

    String ejbName = "ejb:" + appName + "/" + moduleName + "/" + distinctName + "/" + beanName + "!" + viewClassName;
    // ejbName =
    // "ejb:/TetramBDEJB/albumService!org.tetram.bdtheque.service.AlbumService";

    return ejbName;
  }

  @SuppressWarnings("unchecked")
  private static <T> T lookupRemoteStateless(Class<T> e) throws NamingException {
    final Hashtable<String, String> jndiProperties = new Hashtable<String, String>();
    jndiProperties.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
    final Context context = new InitialContext(jndiProperties);

    String ejbName = buildEjbName(e);
    Logger.getLogger(ClientTest.class.getName()).log(Level.INFO, ejbName);
    return (T) context.lookup(ejbName);
  }

  @SuppressWarnings({ "unused", "unchecked" })
  private static <T> T lookupRemoteStateful(Class<T> e) throws NamingException {
    final Hashtable<String, String> jndiProperties = new Hashtable<String, String>();
    jndiProperties.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
    final Context context = new InitialContext(jndiProperties);

    String ejbName = buildEjbName(e) + "?stateful";
    Logger.getLogger(ClientTest.class.getName()).log(Level.INFO, ejbName);
    return (T) context.lookup(ejbName);
  }
}
