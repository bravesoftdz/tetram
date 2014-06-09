package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

import java.util.Locale;

/**
 * Created by Thierry on 24/05/2014.
 */
public class ConversionLite extends AbstractDBEntity {
    private String monnaie1, monnaie2;
    private Double taux;

    public String getMonnaie1() {
        return BeanUtils.trim(monnaie1);
    }

    public void setMonnaie1(String monnaie1) {
        this.monnaie1 = BeanUtils.trim(monnaie1);
    }

    public String getMonnaie2() {
        return BeanUtils.trim(monnaie2);
    }

    public void setMonnaie2(String monnaie2) {
        this.monnaie2 = BeanUtils.trim(monnaie2);
    }

    public Double getTaux() {
        return taux;
    }

    public void setTaux(Double taux) {
        this.taux = taux;
    }

    @Override
    public String buildLabel() {
        return String.format(Locale.getDefault(), "1 %s = %.2f %s", monnaie1, taux, monnaie2);
    }
}
