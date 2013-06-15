package org.tetram.bdtheque.data.bean;

public class InitialeSerieBean extends InitialeFormatedBean {

    @Override
    public String getLabel() {
        if (getValue() == null || "-1".equals(getValue()))
            return "<Sans série>";
        else
            return super.getLabel();
    }
}
