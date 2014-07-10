package org.tetram.bdtheque.data.bean;

import java.util.List;

/**
 * Created by Thierry on 11/06/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public interface ScriptEntity {

    List<String> getAssociations();

    void setAssociations(List<String> associations);

    boolean addAssociation(String association);

    boolean removeAssociation(String association);

}
