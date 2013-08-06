package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;

public class InitialeSerieBean extends InitialeFormatedBean {

    @Override
    public String getRawLabel() {
        if ((getValue() == null) || "-1".equals(getValue()))
            return BDThequeApplication.getInstance().getString(R.string.initiale_sans_serie);
        else
            return super.getRawLabel();
    }
}
