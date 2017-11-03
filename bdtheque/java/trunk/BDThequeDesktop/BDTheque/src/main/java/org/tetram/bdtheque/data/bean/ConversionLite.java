/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ConversionLite.java
 * Last modified by Tetram, on 2014-07-29T11:02:07CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.DoubleProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.beans.property.StringProperty;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;
import org.tetram.bdtheque.utils.I18nSupport;

/**
 * Created by Thierry on 24/05/2014.
 */

public class ConversionLite extends AbstractDBEntity {

    @NonNls
    private static final String CONVERSION_FORMAT = "1 %s = %.2f %s";

    private final StringProperty monnaie1 = new AutoTrimStringProperty(this, "monnaie1", null);
    private final StringProperty monnaie2 = new AutoTrimStringProperty(this, "monnaie2", null);
    private final DoubleProperty taux = new SimpleDoubleProperty(this, "taux", 0);

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return ConversionLite.class;
    }


    public String getMonnaie1() {
        return monnaie1.get();
    }

    public void setMonnaie1(String monnaie1) {
        this.monnaie1.set(monnaie1);
    }

    public StringProperty monnaie1Property() {
        return monnaie1;
    }

    public String getMonnaie2() {
        return monnaie2.get();
    }

    public void setMonnaie2(String monnaie2) {
        this.monnaie2.set(monnaie2);
    }

    public StringProperty monnaie2Property() {
        return monnaie2;
    }

    public double getTaux() {
        return taux.get();
    }

    public void setTaux(double taux) {
        this.taux.set(taux);
    }

    public DoubleProperty tauxProperty() {
        return taux;
    }

    @Override
    public String buildLabel() {
        return String.format(I18nSupport.getLocale(), CONVERSION_FORMAT, getMonnaie1(), getTaux(), getMonnaie2());
    }

}
