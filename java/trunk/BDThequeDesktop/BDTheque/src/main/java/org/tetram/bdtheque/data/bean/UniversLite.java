package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
public class UniversLite extends AbstractDBEntity {

    private String nomUnivers;

    public String getNomUnivers() {
        return BeanUtils.trimOrNull(nomUnivers);
    }

    public void setNomUnivers(String nomUnivers) {
        this.nomUnivers = BeanUtils.trimOrNull(nomUnivers);
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomUnivers());
    }

}
