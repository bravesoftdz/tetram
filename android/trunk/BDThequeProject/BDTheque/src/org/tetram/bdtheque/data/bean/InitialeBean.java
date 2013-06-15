package org.tetram.bdtheque.data.bean;

public class InitialeBean {
    private String value;
    private int count;
    private String label;

    public InitialeBean() {
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getLabel() {
        if (value == null || "-1".equals(value))
            return "<Inconnu>";
        else
            return label.trim();
    }

    public void setLabel(String label) {
        this.label = label;
    }

    @Override
    public int hashCode() {
        if (value == null)
            return new Integer(0).hashCode();
        else
            return super.hashCode();
    }

    public static InitialeBean createInstance(Class<? extends InitialeBean> aClass, String label, int count, String value) {
        InitialeBean t = null;
        try {
            t = aClass.newInstance();
            t.setLabel(label);
            t.setValue(value);
            t.setCount(count);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return t;
    }

}
