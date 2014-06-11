package org.tetram.bdtheque.data.bean;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by Thierry on 11/06/2014.
 */
public class AbstractScriptEntity extends AbstractDBEntity implements ScriptEntity {

    private Set<String> associations = new HashSet<>();

    @Override
    public Set<String> getAssociations() {
        return null;
    }

    @Override
    public void setAssociations(Set<String> associations) {

    }

    @Override
    public boolean addAssociation(String association) {
        return false;
    }

    @Override
    public boolean removeAssociation(String association) {
        return false;
    }
}
