package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.MapKey;
import org.tetram.bdtheque.data.bean.CategorieValeurListe;
import org.tetram.bdtheque.data.bean.DefaultValeurListe;

import java.util.Map;

/**
 * Created by Thierry on 28/05/2014.
 */
@XMLFile("/org/tetram/bdtheque/data/dao/mappers/ValeurListe.xml")
public interface ValeurListeMapper extends BaseMapperInterface {
    @MapKey("categorie")
    Map<CategorieValeurListe, DefaultValeurListe> getListDefaultValeur();
}
