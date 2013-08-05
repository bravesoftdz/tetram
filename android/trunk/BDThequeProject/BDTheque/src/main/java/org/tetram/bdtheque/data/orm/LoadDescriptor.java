package org.tetram.bdtheque.data.orm;

import java.util.HashMap;
import java.util.Map;

public class LoadDescriptor {
    final Map<SimplePropertyDescriptor, String> alias = new HashMap<SimplePropertyDescriptor, String>();
    final Map<String, LoadDescriptor> childAlias = new HashMap<String, LoadDescriptor>();

    public Map<SimplePropertyDescriptor, String> getAlias() {
        return this.alias;
    }

    public Map<String, LoadDescriptor> getChildAlias() {
        return this.childAlias;
    }

}
