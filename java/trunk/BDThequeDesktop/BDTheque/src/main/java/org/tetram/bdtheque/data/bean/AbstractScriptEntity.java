package org.tetram.bdtheque.data.bean;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by Thierry on 11/06/2014.
 */
public abstract class AbstractScriptEntity extends AbstractDBEntity implements ScriptEntity {

    private Set<String> associations = new HashSet<>();

    @Override
    public Set<String> getAssociations() {
        return associations;
    }

    @Override
    public void setAssociations(Set<String> associations) {
        this.associations = associations;
    }

    @Override
    public boolean addAssociation(String association) {
        return associations.add(association);
    }

    @Override
    public boolean removeAssociation(String association) {
        return associations.remove(association);
    }

}
