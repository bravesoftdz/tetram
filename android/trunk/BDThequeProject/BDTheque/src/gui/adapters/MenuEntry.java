package org.tetram.bdtheque.gui.adapters;

public class MenuEntry {
    private final String label;
    @SuppressWarnings("InstanceVariableNamingConvention")
    private final int id;

    public MenuEntry(String label, int id) {
        super();
        this.label = label;
        this.id = id;
    }

    @Override
    public String toString() {
        return this.label;
    }

    int getId() {
        return this.id;
    }
}
