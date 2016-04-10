package org.tetram.bdtheque.gui.adapters;

public class MenuEntry {
    private final String label;
    @SuppressWarnings("InstanceVariableNamingConvention")
    private final int id;
    private final int drawableId;

    public MenuEntry(String label, int id) {
        this(label, id, 0);
    }

    public MenuEntry(String label, int id, int drawableId) {
        super();
        this.label = label;
        this.id = id;
        this.drawableId = drawableId;
    }

    @Override
    public String toString() {
        return this.label;
    }

    int getId() {
        return this.id;
    }

    public int getDrawableId() {
        return this.drawableId;
    }

}
