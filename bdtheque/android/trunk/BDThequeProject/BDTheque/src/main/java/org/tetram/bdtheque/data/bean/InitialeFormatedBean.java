package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.StringUtils;

public class InitialeFormatedBean extends InitialeBean {

    @Override
    public String getLabel() {
        return StringUtils.formatTitre(super.getLabel());
    }
}
