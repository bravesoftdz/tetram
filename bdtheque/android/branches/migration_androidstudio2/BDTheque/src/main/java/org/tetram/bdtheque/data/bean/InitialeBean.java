package org.tetram.bdtheque.data.bean;

public class InitialeBean {
    private String value;
    private int count;
    private String label;

    public static InitialeBean createInstance(Class<? extends InitialeBean> aClass, String label, int count, String value) {
        InitialeBean t = null;
        try {
            t = aClass.getConstructor().newInstance();
            t.setLabel(label);
            t.setValue(value);
            t.setCount(count);
        } catch (final Exception e) {
            e.printStackTrace();
        }
        return t;
    }

    public String getValue() {
        return this.value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Integer getCount() {
        return this.count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    @SuppressWarnings("NonFinalFieldReferencedInHashCode")
    @Override
    public int hashCode() {
        if (this.value == null)
            return Integer.valueOf(0).hashCode();
        else
            return super.hashCode();
    }

    @Override
    public String toString() {
        return getLabel();
    }

    public String getLabel() {
        return this.getRawLabel();
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getRawLabel() {
        if ((this.value == null) || "-1".equals(this.value))
            return "<Inconnu>";
        else
            return this.label.trim();
    }
}
