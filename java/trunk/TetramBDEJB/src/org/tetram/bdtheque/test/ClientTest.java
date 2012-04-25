package org.tetram.bdtheque.test;

import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

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
    final Hashtable<String, String> jndiProperties = new Hashtable<String, String>();

    jndiProperties.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
    final Context context = new InitialContext(jndiProperties);

    AlbumService album = (AlbumService) context
        .lookup("ejb:/TetramBDEJB/albumService!org.tetram.bdtheque.service.AlbumService");

    Logger.getLogger(ClientTest.class.getName()).log(Level.INFO, album.test());
    
    Map<Object, List<Album>> list = album.getListByAnnee();
    Logger.getLogger(ClientTest.class.getName()).log(Level.INFO, list.toString());

  }

}
