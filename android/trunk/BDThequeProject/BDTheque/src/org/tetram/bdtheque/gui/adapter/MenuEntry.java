package org.tetram.bdtheque.gui.adapter;

public class MenuEntry {
    private String label;
    private int id;

    public MenuEntry(String label, int id) {
        this.label = label;
        this.id = id;
    }

    @Override
    public String toString() {
        return label;
    }

    int getId() {
        return id;
    }
}
