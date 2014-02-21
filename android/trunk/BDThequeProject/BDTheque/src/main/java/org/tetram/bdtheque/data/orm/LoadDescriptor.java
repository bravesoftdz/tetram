package org.tetram.bdtheque.data.orm;

import java.util.HashMap;
import java.util.Map;

public class LoadDescriptor {
    private final Map<SimplePropertyDescriptor, String> alias = new HashMap<>();
    private final Map<String, LoadDescriptor> childAlias = new HashMap<>();

    public Map<SimplePropertyDescriptor, String> getAlias() {
        return this.alias;
    }

    public Map<String, LoadDescriptor> getChildAlias() {
        return this.childAlias;
    }

}
