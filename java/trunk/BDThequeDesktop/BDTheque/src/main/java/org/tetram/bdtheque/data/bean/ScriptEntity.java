package org.tetram.bdtheque.data.bean;

import java.util.Set;

/**
 * Created by Thierry on 11/06/2014.
 */
public interface ScriptEntity {

    Set<String> getAssociations();

    void setAssociations(Set<String> associations);

    boolean addAssociation(String association);

    boolean removeAssociation(String association);

}
